import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:time_managment_app/main.dart'; // Adjust the import path to your main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:time_managment_app/firebase_options.dart'; // Adjust to point to your Firebase options file

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Launch the app
    await tester.pumpWidget(MyApp());

    // Wait for the app to settle
    await tester.pumpAndSettle(const Duration(seconds: 20));

    // Verify the app title is present
    expect(find.text('Personal Time Manager'), findsOneWidget);
  });
}
