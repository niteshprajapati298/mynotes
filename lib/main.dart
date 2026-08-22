import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
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
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        notesRoute: (context) => const NotesView(),
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
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            final emailVerified = user?.isEmailVerified ?? false;
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
