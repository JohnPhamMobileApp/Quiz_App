import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomePage extends StatelessWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to the Quiz App!'),
            // Button to navigate to the Quiz Setup Screen
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/quiz_setup');
              },
              child: const Text('Go to Quiz Setup'),
            ),
            // Optional: Button to log out (for testing)
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
