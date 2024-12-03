import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // Import for kIsWeb
import 'login_page.dart';
import 'home_page.dart';
import 'quiz_setup_screen.dart';  // Import the Quiz Setup Screen
import 'quiz_screen.dart';        // Import the Quiz Screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for web and other platforms
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCLs8reG-AQOJqeROq4kAMYKTgPsvEvJaY",
        authDomain: "quiz-5508e.firebaseapp.com",
        projectId: "quiz-5508e",
        storageBucket: "quiz-5508e.firebasestorage.app",
        messagingSenderId: "1097727424055",
        appId: "1:1097727424055:web:03adfffa99ae6e06e7f1b2",
        measurementId: "G-ZHBDP40PEY"
      ),
    );
  } else {
    await Firebase.initializeApp(); // Initialize for other platforms like Android/iOS
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthenticationWrapper(), // Decides the starting page
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(title: 'Home Page'),
        '/quiz_setup': (context) => QuizSetupScreen(), // Add route to Quiz Setup Screen
        '/quiz': (context) => QuizScreen(), // Add route to Quiz Screen
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to Firebase authentication state
    return StreamBuilder<User?>( 
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while checking auth state
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          // If the user is logged in, navigate to the HomePage
          return const HomePage(title: 'Home Page');
        } else {
          // If the user is not logged in, show the LoginPage
          return const LoginPage();
        }
      },
    );
  }
}
