import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:volunteer_connect/domain/models/applicant_profile.dart';
import 'package:volunteer_connect/presentation/screens/applicant_profile.dart';
import 'package:volunteer_connect/application/providers/applicant_profile_provider.dart';
import 'package:volunteer_connect/domain/repositories/application_action_service_provider.dart';
import 'package:volunteer_connect/infrastructure/data_sources/application_action_service.dart';
import 'package:volunteer_connect/infrastructure/data_sources/applicant_profile_service.dart';

import 'applicant_profile_screen_test.mocks.dart';

@GenerateMocks([ApplicantProfileService, ApplicationActionService])
void main() {
  const testUserId = 'user-1';
  const testEventId = 'event-1';

  final mockProfile = ApplicantProfile(
    id: 1,
    name: 'Test User',
    email: 'test@example.com',
    role: 'Volunteer',
    city: 'Test City',
    phone: '1234567890',
    bio: 'Bio goes here.',
    skills: ['Skill A', 'Skill B'],
    interests: ['Interest X'],
  );

  late MockApplicantProfileService mockProfileService;
  late MockApplicationActionService mockActionService;

  setUp(() {
    mockProfileService = MockApplicantProfileService();
    mockActionService = MockApplicationActionService();

    when(
      mockProfileService.fetchApplicantProfile(testUserId),
    ).thenAnswer((_) async => mockProfile);
    when(mockActionService.approve(testEventId)).thenAnswer((_) async {});
    when(mockActionService.reject(testEventId)).thenAnswer((_) async {});
  });

  testWidgets('Displays profile data and handles approve', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          applicantProfileProvider.overrideWith(
            (ref, userId) async => mockProfile,
          ),
          applicationActionServiceProvider.overrideWithValue(mockActionService),
        ],
        child: const MaterialApp(
          home: ApplicantProfileScreen(
            userId: testUserId,
            eventId: testEventId,
            status: 'pending',
          ),
        ),
      ),
    );

    // Resolve async
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // Verify profile data
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('Test City'), findsOneWidget);
    expect(find.text('1234567890'), findsOneWidget);
    expect(find.text('Bio goes here.'), findsOneWidget);
    expect(find.text('Skill A'), findsOneWidget);
    expect(find.text('Skill B'), findsOneWidget);
    expect(find.text('Interest X'), findsOneWidget);

    // Verify initial status badge
    expect(find.text('PENDING'), findsOneWidget);

    // Scroll to bring the approve button into view
    await tester.scrollUntilVisible(find.text('Approve'), 300.0);
    await tester.pumpAndSettle();

    // Tap Approve and verify
    await tester.tap(find.text('Approve'));
    await tester.pumpAndSettle();

    // Verify that approve was called
    verify(mockActionService.approve(testEventId)).called(1);
    // Status text updated
    expect(find.text('APPROVED'), findsOneWidget);
    // Snackbar shown
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Application Approved'), findsOneWidget);
    // Snackbar shown
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Application Approved'), findsOneWidget);
  });

  testWidgets('Handles reject action', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          applicantProfileProvider.overrideWith(
            (ref, userId) async => mockProfile,
          ),
          applicationActionServiceProvider.overrideWithValue(mockActionService),
        ],
        child: const MaterialApp(
          home: ApplicantProfileScreen(
            userId: testUserId,
            eventId: testEventId,
            status: 'pending',
          ),
        ),
      ),
    );

    // Resolve async
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // Scroll to bring the reject button into view
    await tester.scrollUntilVisible(find.text('Reject'), 300.0);
    await tester.pumpAndSettle();

    // Tap Reject and verify
    await tester.tap(find.text('Reject'));
    await tester.pumpAndSettle();

    verify(mockActionService.reject(testEventId)).called(1);
    expect(find.text('REJECTED'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Application Rejected'), findsOneWidget);
  });
}