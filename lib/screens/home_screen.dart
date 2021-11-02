import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:homework_3/components/convo_list_items.dart';
import 'package:homework_3/models/convo.dart';
import 'package:homework_3/models/user.dart';
import 'package:homework_3/services/firebase_service.dart';
import 'package:provider/provider.dart';

class HomeBuilder extends StatelessWidget {
  HomeBuilder({Key? key}) : super(key: key);
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Convo>>.value(
        initialData: const [],
        value: FirebaseService().streamConversations(_user!.uid),
        child: MessageDetailsProvider(user: _user));
  }
}

class MessageDetailsProvider extends StatelessWidget {
  const MessageDetailsProvider({Key? key, required this.user})
      : super(key: key);

  final User? user;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Users>>.value(
        initialData: const [],
        value: FirebaseService()
            .getUsersByList(getUserIds(Provider.of<List<Convo>>(context))),
        child: HomeScreen(user: user));
  }

  List<String> getUserIds(List<Convo> _convos) {
    final List<String> users = [];
    if (_convos.isNotEmpty) {
      for (Convo c in _convos) {
        c.userIds[0] != user!.uid
            ? users.add(c.userIds[0])
            : users.add(c.userIds[1]);
      }
    }
    return users;
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.user}) : super(key: key);
  final User? user;

  @override
  Widget build(BuildContext context) {
    final List<Convo> _convos = Provider.of<List<Convo>>(context);
    final List<Users> _users = Provider.of<List<Users>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                FirebaseService().userLogout(context);
              },
              icon: const Icon(
                FontAwesomeIcons.signOutAlt,
              ),
              tooltip: 'LOGOUT',
            ),
            const Text(
              'MESSAGES',
              style: TextStyle(fontSize: 18),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/profileScreen');
              },
              icon: const Icon(FontAwesomeIcons.user),
              tooltip: 'PROFILE',
            ),
            IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/messageProvider'),
              icon: const Icon(FontAwesomeIcons.plus, size: 30),
              tooltip: 'NEW MESSAGE',
            ),
          ],
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: getWidgets(context, user, _convos, _users),
      ),
    );
  }

  List<Widget> getWidgets(BuildContext context, User? user, List<Convo> _convos,
      List<Users> _users) {
    final List<Widget> list = [];
    if (_convos.isNotEmpty && _users.isNotEmpty && user != null) {
      final Map<String, Users> userMap = getUserMap(_users);
      for (Convo c in _convos) {
        if (c.userIds[0] == user.uid) {
          list.add(ConvoListItem(
              user: user,
              peer: userMap[c.userIds[1]],
              lastMessage: c.lastMessage));
        } else {
          list.add(ConvoListItem(
              user: user,
              peer: userMap[c.userIds[0]],
              lastMessage: c.lastMessage));
        }
      }
    }
    return list;
  }

  Map<String, Users> getUserMap(List<Users> users) {
    final Map<String, Users> userMap = {};
    for (Users u in users) {
      userMap[u.id] = u;
    }
    return userMap;
  }
}
