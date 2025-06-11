import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:volunteer_connect/application/providers/auth_provider.dart';
import 'package:volunteer_connect/application/states/auth_state.dart';
import 'package:volunteer_connect/infrastructure/data_sources/api_client.dart';

import 'package:mockito/annotations.dart';
import 'package:volunteer_connect/presentation/screens/login_screen.dart';

@GenerateMocks([ApiClient])
void main() {}

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier() : super();

  @override
  Future<void> login(String token, Map<String, dynamic> user) async {
    state = token as AuthState;
  }
}

void maain() {
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
  });

  testWidgets('LoginScreen - successful login navigates to volunteer home', (
    WidgetTester tester,
  ) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [authProvider.overrideWith((ref) => FakeAuthNotifier())],
    );

    final testUser = {'name': 'Test User', 'role': 'volunteer'};
    print(testUser);

    when(
      mockApiClient.post(
        any,
        any,
        requiresAuth: anyNamed('requiresAuth'),
        headers: anyNamed('headers'),
        token: anyNamed('token'),
      ),
    ).thenAnswer((_) async => ResponseWrapper());

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    // Act - fill in the form
    await tester.enterText(find.byLabelText('Email'), 'test@example.com');
    await tester.enterText(find.byLabelText('Password'), 'password123');

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    // Assert - Expect some volunteer home content or success path
    expect(find.textContaining('Login failed'), findsNothing);
  });

  testWidgets('LoginScreen - shows error on login failure', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [authProvider.overrideWith((ref) => FakeAuthNotifier())],
    );

    when(
      mockApiClient.post(
        any,
        any,
        requiresAuth: anyNamed('requiresAuth'),
        headers: anyNamed('headers'),
        token: anyNamed('token'),
      ),
    ).thenThrow(Exception('Invalid credentials'));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.enterText(find.byLabelText('Email'), 'fail@example.com');
    await tester.enterText(find.byLabelText('Password'), 'wrongpassword');
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Login failed'), findsOneWidget);
  });
}

class ResponseWrapper {}

extension on CommonFinders {
  FinderBase<Element> byLabelText(String s) {
    throw UnimplementedError('byLabelText is not implemented');
  }
}

class MockApiClient {
  post(any, any2, {required requiresAuth, required headers, required token}) {}
}
