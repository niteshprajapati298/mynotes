
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
   return Column(
        children: [
          Text("Please Verify your email address"),
          TextButton(onPressed: () async { 
             final user = FirebaseAuth.instance.currentUser;
             await user?.sendEmailVerification();
          }, child: const Text('Send Email Verification')),
        ],
      );
  }
}
// Human language mein read karo:
//
// class RegisterView extends StatefulWidget {
// → Main ek Flutter Stateful Widget bana raha hoon.
//
// const RegisterView({super.key});
// → Ye RegisterView ka constructor hai.
//
// @override
// → Main parent class (StatefulWidget) ke createState() method ko
//   apne tarike se implement/override kar raha hoon.
//
// State<RegisterView> createState()
// → Flutter, jab RegisterView ko build karna ho, is method ko call karega.
//   Ye method ek State object return karega.
//
// Overall flow:
//
// class
//   ↓
// extends StatefulWidget
//   ↓
// constructor
//   ↓
// @override
//   ↓
// createState()
//   ↓
// return State object
//
// Simple meaning:
// "Flutter, ye meri RegisterView hai.
//  Jab ise screen par dikhana ho, createState() ko call karna
//  aur main tujhe bataunga ki UI kaisi honi chahiye."
