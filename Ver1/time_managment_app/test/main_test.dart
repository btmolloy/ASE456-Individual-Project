import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_managment_app/main.dart';
import 'package:firebase_core/firebase_core.dart';

class MockFirebaseApp extends Mock implements FirebaseApp {}

void main() {
  setUp(() {
    registerFallbackValue(MockFirebaseApp());
  });

  testWidgets('Main app launches successfully', (WidgetTester tester) async {
    // Mock Firebase initialization
    await tester.runAsync(() async {
      await Firebase.initializeApp();
    });

    // Pump the app
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    // Verify app loaded successfully
    expect(find.text('Personal Time Manager'), findsOneWidget);
  });
}
