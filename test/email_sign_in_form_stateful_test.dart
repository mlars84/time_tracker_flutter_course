import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockAuth extends Mock implements AuthBase {}

void main() {
  MockAuth mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });

  Future<void> pumpEmailSignInForm(WidgetTester tester) async {
    await tester.pumpWidget(Provider<AuthBase>(
      builder: (_) => mockAuth,
      child: MaterialApp(home: Scaffold(body: EmailSignInFormStateful())),
    ));
  }

  group('sign in', () {
    testWidgets(
        'signInWithEmailAndPassword not called when email '
        'AND password are empty', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final signInButton = find.text('Sign in');

      await tester.tap(signInButton);

      verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
    });

    testWidgets('signInWithEmailAndPassword not called when email field empty',
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final signInButton = find.text('Sign in');

      await tester.tap(signInButton);

      verifyNever(mockAuth.signInWithEmailAndPassword('', 'password'));
    });

    testWidgets(
        'signInWithEmailAndPassword not called when password field empty',
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final signInButton = find.text('Sign in');

      await tester.tap(signInButton);

      verifyNever(mockAuth.signInWithEmailAndPassword('email@email.com', ''));
    });

    testWidgets('signInWithEmailAndPassword called when neither field empty',
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(ValueKey('emailField'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(ValueKey('passwordField'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      verify(mockAuth.signInWithEmailAndPassword(email, password));
    });
  });

  group('register', () {
    testWidgets(
        'tapping on secondary button displays "Create an account" text', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final registerButton = find.byKey(ValueKey('registerButton'));

      await tester.tap(registerButton);

      await tester.pump();

      expect(find.text('Create an account'), findsOneWidget);
    });

    // testWidgets('signInWithEmailAndPassword not called when email field empty',
    //     (WidgetTester tester) async {
    //   await pumpEmailSignInForm(tester);

    //   final signInButton = find.text('Sign in');

    //   await tester.tap(signInButton);

    //   verifyNever(mockAuth.signInWithEmailAndPassword('', 'password'));
    // });

    // testWidgets(
    //     'signInWithEmailAndPassword not called when password field empty',
    //     (WidgetTester tester) async {
    //   await pumpEmailSignInForm(tester);

    //   final signInButton = find.text('Sign in');

    //   await tester.tap(signInButton);

    //   verifyNever(mockAuth.signInWithEmailAndPassword('email@email.com', ''));
    // });

    // testWidgets('signInWithEmailAndPassword called when neither field empty',
    //     (WidgetTester tester) async {
    //   await pumpEmailSignInForm(tester);

    //   const email = 'email@email.com';
    //   const password = 'password';

    //   final emailField = find.byKey(ValueKey('emailField'));
    //   expect(emailField, findsOneWidget);
    //   await tester.enterText(emailField, email);

    //   final passwordField = find.byKey(ValueKey('passwordField'));
    //   expect(passwordField, findsOneWidget);
    //   await tester.enterText(passwordField, password);

    //   await tester.pump();

    //   final signInButton = find.text('Sign in');
    //   await tester.tap(signInButton);

    //   verify(mockAuth.signInWithEmailAndPassword(email, password));
    // });
  });
}
