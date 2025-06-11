import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteer_connect/presentation/widgets/category_chip.dart';

void main() {
  group('CategoryChip Widget Tests', () {
    testWidgets('shows the given label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              label: 'Health',
              selected: false,
              onSelected: () {},
            ),
          ),
        ),
      );

      expect(find.text('Health'), findsOneWidget);
    });

    testWidgets('calls onSelected when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              label: 'Education',
              selected: false,
              onSelected: () { tapped = true; },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ChoiceChip));
      await tester.pump(); // advance frame
      expect(tapped, isTrue);
    });

    testWidgets('unselected state has black text, transparent border',
            (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CategoryChip(
                  label: 'Environment',
                  selected: false,
                  onSelected: () {},
                ),
              ),
            ),
          );

          final chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
          final labelStyle = chip.labelStyle!;
          final side = (chip.shape as RoundedRectangleBorder).side;
          expect(labelStyle.color, Colors.black87);
          expect(side.color, Colors.transparent);
        });

    testWidgets('selected state has white text, blue border & background',
            (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CategoryChip(
                  label: 'Community',
                  selected: true,
                  onSelected: () {},
                ),
              ),
            ),
          );

          final chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
          final labelStyle = chip.labelStyle!;
          final side = (chip.shape as RoundedRectangleBorder).side;
          expect(labelStyle.color, Colors.white);
          expect(labelStyle.fontWeight, FontWeight.w600);
          expect(side.color, const Color(0xFF3597da));
          expect(chip.selectedColor, const Color(0xFF3597da));
        });
  });
}
