import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/logger_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  Future<void> checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await user.reload();

    final updatedUser = FirebaseAuth.instance.currentUser;

    if (updatedUser?.emailVerified == true) {
      logger.i('Email is verified');

      if (!context.mounted) return;

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/notes/', (route) => false);
    } else {
      logger.i('Email is NOT verified');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email is not verified yet')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: Column(
        children: [
          Text("Please Verify Email"),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
               await user?.sendEmailVerification();

              logger.i('Verification email sent successfully');

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Verification email sent')),
              );
            },
            child: const Text('Send Email Verification'),
          ),
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
