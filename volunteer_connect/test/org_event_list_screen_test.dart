import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:volunteer_connect/domain/models/org_event.dart';
import 'package:volunteer_connect/infrastructure/data_sources/org_event_api_service.dart';
import 'package:volunteer_connect/presentation/screens/org_event.dart';
import 'package:volunteer_connect/domain/repositories/org_event_api_service_provider.dart';

import 'org_event_list_screen_test.mocks.dart';

@GenerateMocks([OrgEventApiService])
void main() {
  late MockOrgEventApiService mockApiService;

  setUp(() {
    mockApiService = MockOrgEventApiService();
  });

  testWidgets('OrgEventListScreen displays mock events (including offscreen)', (
    WidgetTester tester,
  ) async {
    final mockEvents = [
      OrgEvent(
        id: 1,
        uuid: 'uuid-1',
        title: 'Mock Event 1',
        subtitle: 'Subtitle 1',
        category: 'Education',
        date: '2025-07-01',
        time: '10:00 AM',
        location: 'Location 1',
        spotsLeft: 5,
        image: null,
      ),
      OrgEvent(
        id: 2,
        uuid: 'uuid-2',
        title: 'Mock Event 2',
        subtitle: 'Subtitle 2',
        category: 'Health',
        date: '2025-07-02',
        time: '2:00 PM',
        location: 'Location 2',
        spotsLeft: 3,
        image: null,
      ),
    ];

    //stub the API
    when(mockApiService.fetchOrgEvents()).thenAnswer((_) async => mockEvents);

    // pump the screen
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orgEventApiServiceProvider.overrideWithValue(mockApiService),
        ],
        child: const MaterialApp(home: OrgEventListScreen()),
      ),
    );

    //async resolution
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    //verify first event
    expect(find.text('Mock Event 1'), findsOneWidget);

    //drag the vertical ListView up
    final listFinder = find.byType(ListView).last;
    await tester.drag(listFinder, const Offset(0, -300));
    await tester.pumpAndSettle();

    //verify second event appears
    expect(find.text('Mock Event 2'), findsOneWidget);
  });
}
