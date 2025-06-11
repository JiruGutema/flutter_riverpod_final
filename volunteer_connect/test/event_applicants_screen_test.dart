// test/event_applicants_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:volunteer_connect/domain/models/applicant.dart';
import 'package:volunteer_connect/presentation/screens/event_applicants_screen.dart';
import 'package:volunteer_connect/application/providers/applicants_provider.dart';
import 'package:volunteer_connect/presentation/widgets/search_bar.dart';
void main() {
  const testEventId = 'test-event';

  final mockApplicants = [
    Applicant(
      userId: 1,
      name: 'Alice',
      email: 'alice@example.com',
      status: 'pending',
      appliedAt: DateTime.parse('2025-06-01T10:00:00Z'),
    ),
    Applicant(
      userId: 2,
      name: 'Bob',
      email: 'bob@example.com',
      status: 'approved',
      appliedAt: DateTime.parse('2025-06-02T11:00:00Z'),
    ),
  ];

  testWidgets('SearchBarWidget calls onChanged and shows hint', (tester) async {
    String changedValue = '';
    await tester.pumpWidget(
       MaterialApp(
        home: Scaffold(
          body: SearchBarWidget(
            hintText: 'Test Hint',
            onChanged: (value) => changedValue = value,
          ),
        ),
      ),
    );

    expect(find.text('Test Hint'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'hello');
    expect(changedValue, 'hello');
  });

  testWidgets('EventApplicantsScreen filters and displays applicants', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          applicantsProvider.overrideWith(
            (ref, eventId) async => mockApplicants,
          ),
        ],
        child: const MaterialApp(
          home: EventApplicantsScreen(eventId: testEventId),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // Should show total count = 2
    expect(find.text('2'), findsOneWidget);

    // Both names visible
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);

    // Enter search matching only 'Bob'
    await tester.enterText(find.byType(TextField), 'bob');
    await tester.pumpAndSettle();

    // Now only Bob should remain, count = 1
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Alice'), findsNothing);
    expect(find.text('Bob'), findsOneWidget);

    // Enter a query matching none
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();

    expect(find.text('No applicants match your search.'), findsOneWidget);
  });
}
