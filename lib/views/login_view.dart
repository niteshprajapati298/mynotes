import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/logger_service.dart';
import 'package:mynotes/utilities/showErrorDialogue.dart';

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

  @override
  Widget build(BuildContext context) {
    // build() method login screen ka widget tree banata hai.
    // Yahan Scaffold ke andar app bar aur body define hue hain.
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text.trim();
              final password = _password.text.trim();
              try {
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                logger.i('Signed In Successfully: ${userCredential.user?.uid}');
                logger.i("usercredential : $userCredential");
                _email.clear();
                _password.clear();

                if (!context.mounted) return;
                final emailVerified =
                    userCredential.user?.emailVerified ?? false;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  emailVerified ? notesRoute : verifyEmailRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                if (!context.mounted) return;

                if (e.code == 'user-not-found') {
                  await showErrorDialog(context, 'User Not Found');
                } else if (e.code == 'wrong-password') {
                  await showErrorDialog(context, 'Wrong Password');
                } else if (e.code == 'invalid-credential') {
                  await showErrorDialog(context, 'Invalid email or password');
                }
              } catch (e) {
                showErrorDialog(context, e.toString());
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: Text("Not registered yet? Register here!"),
          ),
        ],
      ),
    );
  }
}


