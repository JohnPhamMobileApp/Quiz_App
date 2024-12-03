import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart'; // Import LoginPage to navigate back to login

class HomePage extends StatelessWidget {
  final String title;

  const HomePage({super.key, required this.title});

  // Function to handle user sign out
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to LoginPage after signing out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

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
            // Display a greeting message with the user's email
            Text(
              'Welcome, ${FirebaseAuth.instance.currentUser?.email ?? 'User'}!',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            // Sign out button
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
