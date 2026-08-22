import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/logger_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  Future<void> checkEmailVerification() async {
    final user = AuthService.firebase().currentUser;


    if (user == null) {
      logger.i('No current user found during verification check; redirecting to login');
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
      return;
    }

    try {
      // `user` is an `AuthUser` wrapper and doesn't expose `reload()`.
      // Use the provider to reload the underlying Firebase user, then
      // read the updated `AuthUser` from the service.
      await AuthService.firebase().reloadUser();
      final updatedUser = AuthService.firebase().currentUser;

      if (updatedUser?.isEmailVerified == true) {
        logger.i('Email is verified');

        if (!mounted) return;

        Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
        return;
      }

      logger.i('Email is NOT verified after reload');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email is not verified yet')),
      );
    } on FirebaseAuthException catch (e) {
      logger.i('FirebaseAuthException during verification check: ${e.code} ${e.message}');
        if (e.code == 'user-not-found') {
        // If the user was removed on the server, force sign-out and go to login.
        await AuthService.firebase().logOut();
          if (!mounted) return;
          Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
      } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message ?? e.code}')),
          );
      }
    } catch (e, st) {
      logger.i('Unexpected error while checking verification: $e');
      logger.i(st);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute,
              (route) => false,
            );
          },
        ),
      ),
      body: Column(
        children: [
          Text("Email Verification Sent! Verify Your Email"),
          TextButton(
            onPressed: () async {
              await checkEmailVerification();
            },
            child: const Text('I have verified my email'),
          ),
        ],
      ),
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
