import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/showErrorDialogue.dart';

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
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();
                _email.clear();
                _password.clear();
                if (!mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
              } on WeakPasswordAuthException {
                await showErrorDialog(context, "Password is Weak");
              } on InvalidCredentialsAuthException {
                await showErrorDialog(context, "Invalid Email");
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, "Email Already In Use");
              } on GenricAuthException {
                await showErrorDialog(context, "Registeration Failed");
              }
            },
            child: const Text('Register'),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Already have an account? Login Here"),
          ),
        ],
      ),
    );
  }
}
