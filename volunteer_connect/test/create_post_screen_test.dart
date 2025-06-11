import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:volunteer_connect/application/providers/auth_provider.dart';
import 'package:volunteer_connect/application/states/auth_state.dart';
import 'package:volunteer_connect/infrastructure/core/dio_provider.dart';
import 'package:volunteer_connect/presentation/screens/post_screen.dart';

// Replace with your actual AuthState
class FakeAuthState {
  final String token = "fake_token";
}

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
  });

  testWidgets('CreatePostScreen submits form and shows success snackbar', (WidgetTester tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) => AuthNotifier()..state = AuthState(token: "fake_token")),
        dioProvider.overrideWith((ref) => mockDio),
      ],
    );

    when(mockDio.post("v", data: anyNamed('data'), options: anyNamed('options')))
        .thenAnswer((_) async => Response(
              data: {'message': 'Success'},
              statusCode: 201,
              requestOptions: RequestOptions(path: ''),
            ));

    await tester.pumpWidget(
      ProviderScope(
        overrides: container.overrides,
        child: const MaterialApp(home: CreatePostScreen()),
      ),
    );

    // Fill the form
    await tester.enterText(find.byDecoration('Title'), 'Test Event');
    await tester.enterText(find.byDecoration('Subtitle'), 'A fun event');
    await tester.enterText(find.byDecoration('Category'), 'Health');
    await tester.enterText(find.byDecoration('Date'), '2025-07-01');
    await tester.enterText(find.byDecoration('Time'), '14:00');
    await tester.enterText(find.byDecoration('Location'), 'City Center');
    await tester.enterText(find.byDecoration('Spots Left'), '10');
    await tester.enterText(find.byDecoration('Description'), 'This is a great event.');
    await tester.enterText(find.byDecoration('Requirement'), 'true');
    await tester.enterText(find.byDecoration('Additional Info'), 'Bring ID');
    await tester.enterText(find.byDecoration('Phone'), '1234567890');
    await tester.enterText(find.byDecoration('Email'), 'test@example.com');
    await tester.enterText(find.byDecoration('Telegram'), '@test_user');

    // Submit the form
    await tester.tap(find.text('Create Post'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Post created successfully.'), findsOneWidget);
  });
}

extension on ProviderContainer {
  get overrides => null;
}

extension on CommonFinders {
  Finder byDecoration(String label) {
    return find.byWidgetPredicate((widget) {
      return widget is TextFormField &&
          widget.decoration?.labelText?.toLowerCase() == label.toLowerCase();
    });
  }
}

extension on TextFormField {
  get decoration => null;
}
