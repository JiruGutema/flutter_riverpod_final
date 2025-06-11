import 'package:flutter/material.dart';
import 'package:volunteer_connect/presentation/widgets/skill_chip.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  testWidgets('SkillChip displays the given label with correct styling',
          (WidgetTester tester) async {
        // 1️ Build the widget inside a MaterialApp to provide
        //    default text direction and theme.
        const testLabel = 'Volunteering';
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SkillChip(label: testLabel),
              ),
            ),
          ),
        );

        // 2️ Verify the Text is present
        final textFinder = find.text(testLabel);
        expect(textFinder, findsOneWidget);

        // 3️ Inspect the Text widget’s style
        final Text textWidget = tester.widget<Text>(textFinder);
        expect(textWidget.style?.fontSize, 14);
        expect(textWidget.style?.fontWeight, FontWeight.bold);
        expect(textWidget.style?.color, const Color.fromRGBO(53, 151, 218, 1));

        // 4️ Locate the Container and verify its decoration
        final containerFinder = find
            .ancestor(of: textFinder, matching: find.byType(Container));
        expect(containerFinder, findsOneWidget);

        final Container container = tester.widget<Container>(containerFinder);
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, const Color.fromRGBO(53, 151, 218, 0.2));
        expect(decoration.borderRadius, BorderRadius.circular(16));

        // 5️ Check padding
        final padding = container.padding as EdgeInsets;
        expect(padding.left, 12);
        expect(padding.right, 12);
        expect(padding.top, 6);
        expect(padding.bottom, 6);
      });
}
