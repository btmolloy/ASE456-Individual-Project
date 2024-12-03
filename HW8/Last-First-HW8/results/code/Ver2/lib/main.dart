import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Show a loading screen while Firebase initializes.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        // Show the app once Firebase initializes.
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Personal Time Manager',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue),
            home: HomeScreen(),
          );
        }
        // Show an error if Firebase fails to initialize.
        return MaterialApp(
          home: Scaffold(
            body: Center(child: Text('Failed to initialize Firebase')),
          ),
        );
      },
    );
  }
}
