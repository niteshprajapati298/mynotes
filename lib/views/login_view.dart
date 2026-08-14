import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/logger_service.dart';


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
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter your email here'),
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
                    .signInWithEmailAndPassword(email: email, password: password);
                logger.i('Signed In Successfully: ${userCredential.user?.uid}');
                logger.i("usercredential : $userCredential");
                _email.clear();
                _password.clear();
      
              } on FirebaseAuthException catch (e) {
                logger.e(
                  'FirebaseAuthException: code=${e.code}, message=${e.message}',
                );
              } catch (e, stack) {
                logger.i('Unexpected error: $e');
                logger.i(stack);
              }
            },
            child: const Text('Login'),
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route)=> false);
          }, child: Text("Not registered yet? Register here!"))
        ],
      ),
    );
  }
}
