import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
// import 'package:mynotes/views/login_view.dart';
// import 'package:mynotes/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      routes: {
        '/login/' : (context) => LoginView(),
        '/register/' : (context) => RegisterView()
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
            // final user = FirebaseAuth.instance.currentUser;
            // final emailVerified = user?.emailVerified ?? false;
            // if(emailVerified){
            //   logger.i("You are a verified a user");
            // }
            // else {
            //    logger.i("You Need to Verify Your Email First");
            //    return const VerifyEmailView();
            // }
            return const LoginView();
            default:
              return const CircularProgressIndicator();
          }
        },
      ); 
  }
}