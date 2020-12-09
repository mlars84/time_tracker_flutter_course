import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockAuth extends Mock implements AuthBase {}

void main() {
  MockAuth mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });

  Future<void> pumpLandingPage(WidgetTester tester) async {
    await tester.pumpWidget(Provider<AuthBase>(
      builder: (_) => mockAuth,
      child: MaterialApp(
        home: LandingPage()
      ),
    ));
  }

  void stubOnAuthStateChangedYields(Iterable<User> onAuthStateChanged) {
    when(mockAuth.onAuthStateChanged).thenAnswer((_) {
      return Stream<User>.fromIterable(onAuthStateChanged);
    });
  }

  group('CircularProgressIndicator', () {
    testWidgets(
       "Stream waiting",
       (WidgetTester tester) async {
         stubOnAuthStateChangedYields([]);

         await pumpLandingPage(tester);

         expect(find.byType(CircularProgressIndicator), findsOneWidget);
       },
    );

    testWidgets(
       "Null user",
       (WidgetTester tester) async {
         stubOnAuthStateChangedYields([null]);

         await pumpLandingPage(tester);

         expect(find.byType(SignInPage), findsOneWidget);
       },
    );
  });
}
