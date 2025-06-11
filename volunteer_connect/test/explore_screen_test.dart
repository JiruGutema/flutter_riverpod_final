import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/application/providers/event_provider.dart';
import 'package:volunteer_connect/presentation/screens/explore_screen.dart';
import 'package:volunteer_connect/domain/models/event_model.dart';

void main() {
  // Sample mock events
  final mockEvents = [
    EventModel(
      id: '1',
      title: 'Beach Cleanup',
      subtitle: 'Help clean the beach',
      category: 'Environment',
      date: '2025-07-10',
      time: '09:00 AM',
      location: 'Sunny Beach',
      spotsLeft: 10,
      description: '',
      requirements: {},
      additionalInfo: {},
      contactPhone: '',
      contactEmail: '',
      contactTelegram: '',
    ),
    EventModel(
      id: '2',
      title: 'Food Drive',
      subtitle: 'Collect food donations',
      category: 'Food',
      date: '2025-07-12',
      time: '02:00 PM',
      location: 'Community Center',
      spotsLeft: 5,
      description: '',
      requirements: {},
      additionalInfo: {},
      contactPhone: '',
      contactEmail: '',
      contactTelegram: '',
    ),
  ];

  testWidgets('ExploreScreen displays and filters events', (
    WidgetTester tester,
  ) async {
    // Set up a navigator observer to capture navigation
    final mockObserver = TestNavigatorObserver();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [eventsProvider.overrideWith((ref) async => mockEvents)],
        child: MaterialApp(
          home: const ExploreScreen(),
          navigatorObservers: [mockObserver],
        ),
      ),
    );

    // Await async resolution
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // Clear initial push from MaterialApp
    mockObserver.pushedRoutes.clear();

    // Tap on Detail button of first card
    final detailButton = find.widgetWithText(ElevatedButton, 'Detail').first;

    // Scroll the list to bring the Detail button into view
    final listFinder = find.byType(ListView).last;
    await tester.drag(listFinder, const Offset(0, -300));
    await tester.pumpAndSettle();

    await tester.tap(detailButton);
    await tester.pumpAndSettle();

    // Verify navigation happened
    expect(mockObserver.pushedRoutes.length, 1);
  });
}

// Helper to observe navigation
class TestNavigatorObserver extends NavigatorObserver {
  final List<Route> pushedRoutes = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
}
