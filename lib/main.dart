import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
// import 'package:mynotes/views/login_view.dart';
// import 'package:mynotes/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // build() method login screen ka widget tree banata hai.
    // Yahan Scaffold ke andar app bar aur body define hue hain.
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            final emailVerified = user?.emailVerified ?? false;
            if(emailVerified){
              print("You are a verified a user");
            }
            else {
               print("You Need to Verify Your Email First");
               return const VerifyEmailView();
            }
              return const Text('Done');
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
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
