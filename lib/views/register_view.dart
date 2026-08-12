import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

// _RegisterViewState ke andar app ka actual UI logic rahega.
//
// initState() mein text controllers banaye jaate hain.
// dispose() mein unhain clean karna zaroori hota hai.
class _RegisterViewState extends State<RegisterView> {
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
    // build() method sab se important hai: yeh widget tree return karta hai.
    // Scaffold mein AppBar aur body rakhe hain.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body:  FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              print('Firebase initialized successfully');
              return Column(
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
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        _email.clear();
                        _password.clear();
                        print('Register success: ${userCredential.user?.uid}');
                      } on FirebaseAuthException catch (e) {
                        print('FirebaseAuthException: code=${e.code}, message=${e.message}');
                         _email.clear();
                        _password.clear();
                      } catch (e, stack) {
                        _email.clear();
                        _password.clear();
                        print('Unexpected error: $e');
                        print(stack);
                      }
                    },
                    child: const Text('Register'),
                  ),
                ],
              );
            default:
              return const Text('Loading...');
          }
        }
      ),
    );
  }
}
