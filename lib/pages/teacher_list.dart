import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeacherListPage extends StatelessWidget {

  const TeacherListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Find A Teacher"), backgroundColor: Colors.grey,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0) ,
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Icon(Icons.person, size: 50,),
                    Text('Mr. Evans', style: TextStyle(fontSize: 50),),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Icon(Icons.person, size: 50,),
                    Text('Dr. Mai', style: TextStyle(fontSize: 50),),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Icon(Icons.person, size: 50,),
                    Text('Mr. Stevens', style: TextStyle(fontSize: 50),),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Icon(Icons.person, size: 50,),
                    Text('Ms. Brown', style: TextStyle(fontSize: 50),),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}