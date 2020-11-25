import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> pumpEmailSignInForm(WidgetTester tester,
      {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(Provider<AuthBase>(
      builder: (_) => mockAuth,
      child: MaterialApp(
        home: Scaffold(
          body: EmailSignInFormStateful(
            onSignedIn: onSignedIn,
          )
        )
      ),
    ));
  }

  /// Simulate sign in success with user being returned 
  void stubSignInWithEmailAndPasswordSucceeds() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
      .thenAnswer((_) => Future<User>.value(User(uid: '123')));
  }

  /// Simulate sign in failure with [PlatformException]
  void stubSignInWithEmailAndPasswordThrows() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
      .thenThrow(PlatformException(code: 'ERROR_WRONG_PASSWORD'));
  }

  group('sign in', () {
    testWidgets(
        'signInWithEmailAndPassword not called when email '
        'AND password are empty'
        'AND user is not signed in',
        (WidgetTester tester) async {

      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      final signInButton = find.text('Sign in');

      await tester.tap(signInButton);

      verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
      expect(signedIn, false);
    });

    testWidgets('signInWithEmailAndPassword not called when email field empty '
        'AND user is not signed in',
        (WidgetTester tester) async {
      
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn =  true);

      final signInButton = find.text('Sign in');

      await tester.tap(signInButton);

      verifyNever(mockAuth.signInWithEmailAndPassword('', 'password'));
      expect(signedIn, false);
    });

    testWidgets(
        'signInWithEmailAndPassword not called when password field empty '
        'AND user is not signed in',
        (WidgetTester tester) async {

      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn =  true);

      final signInButton = find.text('Sign in');

      await tester.tap(signInButton);

      verifyNever(mockAuth.signInWithEmailAndPassword('email@email.com', ''));
      expect(signedIn, false);
    });

    testWidgets('signInWithEmailAndPassword called when neither field empty '
        'AND user is signed in',
        (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      stubSignInWithEmailAndPasswordSucceeds();

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
      expect(signedIn, true);
    });

    testWidgets('WHEN the user enters an invalid email and password '
        'AND user taps on the sign-in button '
        'THEN signInWithEmailAndPassword is called '
        'AND user is not signed in',
        (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      stubSignInWithEmailAndPasswordThrows();

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
      expect(signedIn, false);
    });
  });

  group('register', () {
    testWidgets('tapping on secondary button displays "Create an account" text',
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final registerButton = find.byKey(ValueKey('registerButton'));
      await tester.tap(registerButton);

      await tester.pump();

      expect(find.text('Create an account'), findsOneWidget);
    });

    testWidgets(
        'WHEN user taps on the secondary button'
        'AND user enters the email and password'
        'AND user taps on the register button'
        'THEN createUserWithEmailAndPassword is called',
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final registerButton = find.byKey(ValueKey('registerButton'));
      await tester.tap(registerButton);

      await tester.pump();

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(ValueKey('emailField'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(ValueKey('passwordField'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final createAnAccount = find.text('Create an account');
      await tester.tap(createAnAccount);

      verify(mockAuth.createUserWithEmailAndPassword(email, password));
    });
  });
}
