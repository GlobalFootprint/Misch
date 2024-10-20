import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:misch/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final classCodeController = TextEditingController();
  final studentFirstController = TextEditingController();
  final studentLastController = TextEditingController();


  // sliders
  RangeValues selectedRange = const RangeValues(3, 19);

  // enablers
  bool signInBtnEnabled = true;

  String profile = "";
  final List<String> profiles = ['','Teacher', 'Parent', 'Student'];

  // sign up user
  Future<void> signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match."),),
      );
      return;
    }

    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      if (profile == 'Teacher') {
        await authService.teacherSignUp(
          emailController.text,
          passwordController.text,
          classCodeController.text,
          firstNameController.text,
          lastNameController.text,
          selectedRange,
        );
      } else if (profile == 'Parent') {
        await authService.parentSignUp(
          emailController.text,
          passwordController.text,
          classCodeController.text,
          firstNameController.text,
          lastNameController.text,
          studentFirstController.text,
          studentLastController.text,
        );
      } else {
        await authService.studentSignUp(
          emailController.text,
          passwordController.text,
          classCodeController.text,
          firstNameController.text,
          lastNameController.text,
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString()),
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  const Text('Misch',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),

                  // logo
                  const Image(
                    image: AssetImage("assets/MischFlutterFly.png"),
                    width: 200,
                    height: 200,
                  ),

                  const SizedBox(height: 50),

                  // create an account message
                  const Text(
                    "Let's create an account for you!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // email textfield
                  MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true
                  ),

                  const SizedBox(height: 10),

                  // confirm password textfield
                  MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true
                  ),

                  const SizedBox(height: 25),

                  // type of profile selector
                  DropdownButton(
                      dropdownColor: Colors.white,
                      focusColor: Colors.grey[300],
                      value: profile,
                      onChanged: (newProfile) => setState(() {
                        profile = newProfile!;
                        if (profile == "") {
                          signInBtnEnabled = false;
                        }
                        else {
                          signInBtnEnabled = true;
                        }
                      }),
                      items: profiles.map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        )).toList(),
                  ),

                  const SizedBox(height: 15),

                  Column(
                    children: [
                      // first name
                      MyTextField(
                          controller: firstNameController,
                          hintText: 'First Name',
                          obscureText: false),
                      const SizedBox(height: 15,),
                      MyTextField(
                          controller: lastNameController,
                          hintText: 'Last Name',
                          obscureText: false),
                    ],
                  ),

                  const SizedBox(height: 15,),

                  // teacher specific prompts
                  profile == 'Teacher'
                      ? Column(
                        children: [
                          MyTextField(
                          controller: classCodeController,
                          hintText: 'Generate Class Code',
                          obscureText: false),
                        const SizedBox(height: 15,),

                        // slider for the age range of the classroom
                        const Text('Classroom Age Range:'),
                        RangeSlider(
                          activeColor: Colors.grey,
                          inactiveColor: Colors.white30,
                          values: selectedRange,
                          onChanged: (RangeValues newRange) {
                            setState(() {
                              selectedRange = newRange;
                            });
                          },
                          min: 3,
                          max: 19,
                          divisions: 16,
                          labels: RangeLabels('${selectedRange.start}', '${selectedRange.end}'),
                        ),
                    ],
                  )
                  :
                  // parent specific prompts
                  profile == 'Parent'
                      ? Column(
                        children: [
                          MyTextField(
                              controller: classCodeController,
                              hintText: "Student's Class Code",
                              obscureText: false),
                          const SizedBox(height: 15,),
                          MyTextField(
                              controller: studentFirstController,
                              hintText: "Student's First Name",
                              obscureText: false),
                          const SizedBox(height: 15,),
                          MyTextField(
                              controller: studentLastController,
                              hintText: "Student's Last Name",
                              obscureText: false),
                          const SizedBox(height: 15,),
                        ],
                      )
                  :
                  // student specific prompts
                  profile == 'Student'
                      ? Column(
                    children: [
                      MyTextField(
                          controller: classCodeController,
                          hintText: 'Class Code',
                          obscureText: false),
                      const SizedBox(height: 15,),
                    ],
                    )
                  : const SizedBox(height: 0,),

                  const SizedBox(height: 15,),

                  // sign up button
                  MyButton(onTap: signUp, text: 'Sign Up', enabled: signInBtnEnabled,),

                  const SizedBox(height: 25),

                  // log in prompt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already a member?'),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login now',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 25,)
                ],
              ),
            ),
          ),
        )
    );
  }
}