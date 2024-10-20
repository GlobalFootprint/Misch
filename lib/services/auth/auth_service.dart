import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  // instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // sign user in
  Future<UserCredential> signInWithEmailandPassword(String email, String password) async {
    try {
      // sign in
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      return userCredential;
    }
    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // create a new user
  Future<UserCredential> teacherSignUp(String email, String password, String classCode, String firstName, String lastName, RangeValues ageRange) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      // after creating the user, create a new document for the user in the users collection
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'profile' : 'teacher',
        'class code' : classCode,
        'first name' : firstName,
        'last name' : lastName,
        'age range of classroom' : '${ageRange.start}-${ageRange.end}',
      });

      return userCredential;
    }
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // create a new user
  Future<UserCredential> parentSignUp(String email, String password, String classCode, String firstName, String lastName, String studentFirst, String studentLast) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      // parent's specific student
      Map<String, dynamic> students;
      _fireStore.collection('users')
          .where('profile', isEqualTo: 'student')
          .where('class code', isEqualTo: classCode)
          .where('first name', isEqualTo: studentFirst)
          .where('last name', isEqualTo: studentLast).get().then(
            (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            students = docSnapshot.data();

            // adding students to parents
            _fireStore.collection('users').doc(userCredential.user!.uid).collection('students').doc(students['uid']).set({
              'uid': students['uid'],
              'email': students['email'],
              'profile' : 'student',
              'class code' : students['class code'],
              'first name' : students['first name'],
              'last name' : students['last name'],
            });
          }
        }, onError: (e) => print('Error completing : $e'),
      );

      // after creating the user, create a new document for the user in the users collection
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'profile' : 'parent',
        'class code' : classCode,
        'first name' : firstName,
        'last name' : lastName,
        'student first name' : studentFirst,
        'student last name' : studentLast,
      });

      return userCredential;
    }
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // create a new student user
  Future<UserCredential> studentSignUp(String email, String password, String classCode, String firstName, String lastName) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      // student's specific teacher
      Map<String, dynamic> teachers;
      _fireStore.collection('users').where('profile', isEqualTo: 'teacher').where('class code', isEqualTo: classCode).get().then(
          (querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              teachers = docSnapshot.data();

              // adding students to teacher's classroom
              _fireStore.collection('users').doc(teachers['uid']).collection('classroom').doc(userCredential.user!.uid).set({
                'uid': userCredential.user!.uid,
                'email': email,
                'profile' : 'student',
                'class code' : classCode,
                'first name' : firstName,
                'last name' : lastName,
              });
            }
          }, onError: (e) => print('Error completing : $e'),
      );

      // after creating the user, create a new document for the user in the users collection
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'profile' : 'student',
        'class code' : classCode,
        'first name' : firstName,
        'last name' : lastName,
      });

      return userCredential;
    }
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign user out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}