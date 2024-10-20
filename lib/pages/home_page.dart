import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:misch/pages/chat_page.dart';
import 'package:misch/pages/profile_page.dart';
import 'package:misch/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  String profile = "never updated";

  // sign user out
  void signOut() {
    // get auth
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Home Page'),
        actions: [
          // profile button
          IconButton(
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ))},
            icon: const Icon(Icons.person),
          ),

          // sign out button
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildUserList(),
    );
  }

  // build a list of users except the current logged in user
  Widget _buildUserList() {
    return FutureBuilder(
        future: _findUserProfile(),
        builder: (BuildContext context, snapshot) {
          return StreamBuilder(
              stream: (profile == 'teacher')
                  ? _fireStore
                      .collection('users')
                      .doc(_auth.currentUser!.uid)
                      .collection('classroom')
                      .snapshots()
                  : (profile == 'parent')
                      ? _fireStore
                          .collection('users')
                          .doc(_auth.currentUser!.uid)
                          .collection('students')
                          .snapshots()
                      : (profile == 'student')
                          ? _fireStore.collection('users').snapshots()
                          : _fireStore.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('error');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('loading');
                }

                return ListView(
                  children: snapshot.data!.docs
                      .map<Widget>((doc) => _buildUserListItem(doc))
                      .toList(),
                );
              });
        });
  }

  // build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // display all users except current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email'].split('@')[0]),
        onTap: () {
          // pass the clicked user's UID to the chat page
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverUserEmail: data['email'],
                  receiverUserID: data['uid'],
                ),
              ));
        },
      );
    } else {
      // return empty container
      return Container();
    }
  }

  Future<void> _findUserProfile() async {
    final data =
        await _fireStore.collection('users').doc(_auth.currentUser!.uid).get();
    profile = data.get('profile');
  }
}
