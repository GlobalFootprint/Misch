import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:misch/components/my_button.dart';
import 'package:misch/pages/assignment_form.dart';
import 'package:misch/pages/teacher_list.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton:
      IconButton(
          onPressed: () {
            // pass the clicked user's UID to the chat page
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeacherListPage()
                ));
          },
          icon: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Your Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 175,),
                radius: 100,
              ),
              const SizedBox(height: 25,),
              const Text('Description:'),
              const SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      loremIpsum(words: 40),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                  future: _findUserProfile(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading..');
                    }
                    else if (snapshot.hasError) {
                      return Text('Could not find attributes');
                    }
                    return Column(
                      children: [
                        const SizedBox(height: 25,),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 200.0),
                            child: MyButton(onTap: () {Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AssignmentForm(initialDueDate: DateTime.timestamp())
                                ));},
                                text: "Create New Assignment",
                                enabled: true),
                          ),
                        )
                      ]
                    );
                  }
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _findUserProfile() async {
    String profile = "";
    final data =
        await _fireStore.collection('users').doc(_auth.currentUser!.uid).get();
    profile = data.get('profile');
  }
}