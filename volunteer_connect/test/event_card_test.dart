import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';          // ← new
import 'package:volunteer_connect/domain/models/org_event.dart';
import 'package:volunteer_connect/presentation/widgets/event_card.dart';

void main() {
  group('EventCard Widget Tests', () {
    OrgEvent makeEvent({String? image}) => OrgEvent(
      id: 42,
      title: 'Community Cleanup',
      subtitle: 'Help us keep the park clean',
      date: 'June 20, 2025',
      time: '10:00 AM',
      location: 'Central Park',
      spotsLeft: 5,
      image: image,
      uuid: '',
      category: '',
    );

    testWidgets('renders a NetworkImage when event.image is non-null',
            (tester) async {
          final url = 'https://example.com/photo.jpg';
          final called = <String>[];

          // Wrap the widget build & test in mockNetworkImagesFor:
          await mockNetworkImagesFor(() async {
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: EventCard(
                    event: makeEvent(image: url),
                    onViewApplicants: (id) => called.add(id),
                  ),
                ),
              ),
            );

            // Inspect the Image widget—no real HTTP will be attempted:
            final img = tester.widget<Image>(find.byType(Image).first).image;
            expect(img, isA<NetworkImage>());
            expect((img as NetworkImage).url, url);

            // Tap button and advance one frame:
            await tester.tap(find.text('View Applicants'));
            await tester.pump();
            expect(called, ['42']);
          });
        });

    testWidgets('renders an AssetImage when event.image is null',
            (tester) async {
          final called = <String>[];

          await mockNetworkImagesFor(() async {
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: EventCard(
                    event: makeEvent(image: null),
                    onViewApplicants: (id) => called.add(id),
                  ),
                ),
              ),
            );

            final img = tester.widget<Image>(find.byType(Image).first).image;
            expect(img, isA<AssetImage>());

            await tester.tap(find.byType(ElevatedButton));
            await tester.pump();
            expect(called, ['42']);
          });
        });
  });
}
