import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:homework_3/components/snackbar.dart';
import 'package:homework_3/models/user.dart';
import 'package:homework_3/services/firebase_service.dart';

class NewConversationScreen extends StatelessWidget {
  NewConversationScreen(
      {Key? key,
      required this.uid,
      required this.contact,
      required this.convoID})
      : super(key: key);

  final String uid;
  final Users? contact;
  final String convoID;

  final TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(contact!.fullName),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title:
                          const Text('Enter a valid conversation rating 1-5'),
                      content: TextField(
                        controller: _textFieldController,
                        decoration:
                            const InputDecoration(hintText: "Enter Rating"),
                      ),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('CANCEL'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('SUBMIT'),
                          onPressed: () async {
                            if (int.tryParse(_textFieldController.text) !=
                                    null &&
                                int.tryParse(_textFieldController.text)! >= 1 &&
                                int.tryParse(_textFieldController.text)! <= 5) {
                              try {
                                await FirebaseService().enterRating(
                                    _textFieldController.text, contact!.id);
                                snackbar(
                                    context, 'Rating successfully given.', 5);
                                Navigator.of(context).pop();
                              } catch (error) {
                                throw ErrorDescription(error.toString());
                              }
                            } else {
                              snackbar(context,
                                  'Invalid number. Enter a rating 1-5', 5);
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(FontAwesomeIcons.star),
            ),
          ],
        ),
      ),
      body: ChatScreen(uid: uid, convoID: convoID, contact: contact),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {Key? key,
      required this.uid,
      required this.contact,
      required this.convoID})
      : super(key: key);

  final String uid;
  final Users? contact;
  final String convoID;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String uid;
  late Users? contact;
  late String convoID;

  late List<DocumentSnapshot> listMessage;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    convoID = widget.convoID;
    contact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            buildMessages(),
            buildInput(),
          ],
        )
      ],
    );
  }

  Widget buildInput() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                autofocus: true,
                maxLines: 5,
                controller: textEditingController,
                decoration:
                    const InputDecoration(hintText: "Type your message..."),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text),
              ),
            )
          ],
        ),
      ),
      width: double.infinity,
      height: 100,
    );
  }

  Widget buildMessages() {
    return Flexible(
      child: StreamBuilder(
        stream: FirebaseService().getConvoMessages(convoID),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            listMessage = snapshot.data!.docs;
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemBuilder: (BuildContext context, int index) =>
                  buildItem(index, snapshot.data!.docs[index]),
              itemCount: snapshot.data!.docs.length,
              reverse: true,
              controller: listScrollController,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (!document['read'] && document['idTo'] == uid) {
      FirebaseService().updateMessageRead(document, convoID);
    }

    if (document['idFrom'] == uid) {
      return Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Bubble(
              color: Colors.teal,
              elevation: 0,
              padding: const BubbleEdges.all(10),
              nip: BubbleNip.rightTop,
              child: Text(
                document['content'],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            width: 200,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  child: Bubble(
                    color: Colors.black,
                    elevation: 0,
                    padding: const BubbleEdges.all(10),
                    nip: BubbleNip.leftTop,
                    child: Text(
                      document['content'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  width: 200,
                  margin: const EdgeInsets.only(left: 10),
                )
              ],
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  void onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();
      content = content.trim();
      FirebaseService().sendMessage(
        convoID,
        uid,
        contact!.id,
        content,
        DateTime.now().millisecondsSinceEpoch.toString(),
      );
      listScrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}
