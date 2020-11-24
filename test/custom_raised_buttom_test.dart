import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';

void main() {
  Widget makeTestableWidget({Widget child}) {
    return MaterialApp(home: child);
  }

  group('CustomRaisedButton', () {
    testWidgets('Renders RaisedButton widget', (WidgetTester tester) async {
      Widget customChild = Text('test');
      await tester.pumpWidget(
          makeTestableWidget(child: CustomRaisedButton(child: customChild)));

      final button = find.byType(RaisedButton);

      expect(button, findsOneWidget);
      expect(find.byType(FlatButton), findsNothing);
      expect(find.text('test'), findsOneWidget);
    });

    testWidgets('onPressed callback', (WidgetTester tester) async {
      var pressed = false;
      await tester.pumpWidget(makeTestableWidget(
          child: CustomRaisedButton(onPressed: () => {pressed = true})));

      final button = find.byType(RaisedButton);

      await tester.tap(button);
      expect(pressed, true);
    });
  });
}
