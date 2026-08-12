import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';




// Human language mein read karo:
//
// class LoginView extends StatefulWidget {
// → Main ek Flutter Stateful Widget bana raha hoon.
//
// const LoginView({super.key});
// → Ye LoginView ka constructor hai.
//
// @override
// → Main parent class (StatefulWidget) ke createState() method ko
//   apne tarike se implement/override kar raha hoon.
//
// State<LoginView> createState()
// → Flutter, jab LoginView ko build karna ho, is method ko call karega.
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
// "Flutter, ye meri LoginView hai.
//  Jab ise screen par dikhana ho, createState() ko call karna
//  aur main tujhe bataunga ki UI kaisi honi chahiye."
class LoginView extends StatefulWidget {
  
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}


// _LoginViewState ke andar login screen ka UI logic hai.
//
// initState() mein controllers banate hain, dispose() mein clean karte hain.
class _LoginViewState extends State<LoginView> {
   late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Login")
      ),
    );
  }
}
