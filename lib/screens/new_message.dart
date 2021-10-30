import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:homework_3/components/user_row.dart';
import 'package:homework_3/constants/constants.dart';
import 'package:homework_3/models/user.dart';
import 'package:homework_3/services/firebase_service.dart';
import 'package:provider/provider.dart';

class NewMessageProvider extends StatelessWidget {
  const NewMessageProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Users>>.value(
      value: FirebaseService().streamUsers(),
      initialData: const [],
      child: const NewMessageScreen(),
    );
  }
}

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({Key? key}) : super(key: key);

  @override
  _NewMessageScreenState createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  List<Users> _foundUsers = [];
  void _runFilter(String enteredKeyword, List<Users> _userDirectory) {
    List<Users> results = [];
    if (enteredKeyword.isEmpty) {
      results = [];
    } else {
      results = _userDirectory
          .where((user) => user.fullName
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? _user = FirebaseService().currentUser();
    final List<Users> _userDirectory = Provider.of<List<Users>>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onChanged: (value) {
                _runFilter(value, _userDirectory);
              },
              textAlign: TextAlign.center,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Search Users',
                prefixIcon: const Icon(
                  FontAwesomeIcons.search,
                  color: kAppColor,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _foundUsers.isNotEmpty
                ? ListView(
                    shrinkWrap: true,
                    children: getListViewItems(_foundUsers, _user),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: getListViewItems(_userDirectory, _user),
                  ),
          ],
        ),
      ),
    );
  }
}

List<Widget> getListViewItems(List<Users> userDirectory, User? user) {
  final List<Widget> list = [];
  for (Users contact in userDirectory) {
    if (contact.id != user!.uid) {
      list.add(UserRow(uid: user.uid, contact: contact));
    }
  }
  return list;
}
