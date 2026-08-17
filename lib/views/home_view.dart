import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:mynotes/views/login_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hompage")),
      body: Column(
        children: [
          Text("You are Logged In"),
          TextButton(onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            if(user!=null){
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route)=>false);
            } 
          }, child: Text("Click To Logout")),
        ],
      ),
    );
  }
}
