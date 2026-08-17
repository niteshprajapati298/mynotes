import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/services/logger_service.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
// import 'package:mynotes/views/login_view.dart';
// import 'package:mynotes/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 108, 165, 213),
        ),
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/verifyEmail': (context) => const VerifyEmailView(),
        '/home/': (context) => const NotesView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // build() method login screen ka widget tree banata hai.
    // Yahan Scaffold ke andar app bar aur body define hue hain.

    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            final emailVerified = user?.emailVerified ?? false;
            if (user != null) {
              if (emailVerified) {
                logger.i("You are a verified a user");
                return const NotesView();
              } else if (!emailVerified) {
                return const VerifyEmailView();
              }
            } else if (user == null) {
              return const LoginView();
            }
            return const NotesView();
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
