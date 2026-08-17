import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/logger_service.dart';

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
      appBar: AppBar(title: const Text('Register')),
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
                    .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                _email.clear();
                _password.clear();
                logger.i('Register success: ${userCredential.user?.uid}');
                if (!context.mounted) return;
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/verifyEmail/', (route) => false);
              } on FirebaseAuthException catch (e) {
                logger.i(
                  'FirebaseAuthException: code=${e.code}, message=${e.message}',
                );
                _email.clear();
                _password.clear();
              } catch (e, stack) {
                _email.clear();
                _password.clear();
                logger.i('Unexpected error: $e');
                logger.i(stack);
              }
            },
            child: const Text('Register'),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login/', (route) => false);
            },
            child: const Text("Already have an account? Login Here"),
          ),
        ],
      ),
    );
  }
}
