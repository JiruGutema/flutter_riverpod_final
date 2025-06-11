import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteer_connect/presentation/widgets/search_bar.dart';

void main() {
  testWidgets('SearchBarWidget shows hint, icon, and calls onChanged',
          (WidgetTester tester) async {
        // 1. Capture callback calls
        final entered = <String>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SearchBarWidget(
                hintText: 'Find volunteers…',
                onChanged: (value) => entered.add(value),
              ),
            ),
          ),
        );

        // 2. Hint text appears
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.decoration?.hintText, 'Find volunteers…');

        // 3. Prefix search icon renders
        expect(find.byIcon(Icons.search), findsOneWidget);

        // 4. Simulate typing
        const sample = 'flutter';
        await tester.enterText(find.byType(TextField), sample);
        // pump so onChanged fires
        await tester.pump();

        expect(entered, [sample]);
      });
}
