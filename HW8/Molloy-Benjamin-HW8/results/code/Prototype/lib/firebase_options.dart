import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
        apiKey: "****",
        authDomain: "ase-456-e6305.firebaseapp.com",
        projectId: "ase-456-e6305",
        storageBucket: "ase-456-e6305.firebasestorage.app",
        messagingSenderId: "******",
        appId: "*****",
    );
  }
}
