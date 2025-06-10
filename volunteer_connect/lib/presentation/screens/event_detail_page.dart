// event_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/application/providers/auth_provider.dart';
import 'package:volunteer_connect/domain/models/event_model.dart';
import 'package:volunteer_connect/infrastructure/data_sources/api_client.dart';

class EventDetailPage extends ConsumerWidget {
  final EventModel event;

  const EventDetailPage({super.key, required this.event});

  Future<void> _applyToEvent(BuildContext context, WidgetRef ref) async {
    final token = ref.read(authProvider).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to apply.')),
      );
      return;
    }

    try {
      await ApiClient.post(
        '/event/apply/${event.id}',
        {},
        headers: {'Authorization': 'Bearer $token'},
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully applied to the event!')),
        );
        Navigator.pop(context); // Return to explore screen
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to apply: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/image.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 12),
            Text(
              event.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(event.description),
            const SizedBox(height: 8),
            Text('Date: ${event.date}'),
            Text('Time: ${event.time}'),
            Text('Location: ${event.location}'),
            Text('Spots Left: ${event.spotsLeft}'),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),

                onPressed: () => _applyToEvent(context, ref),
                child: const Text(
                  'Apply',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
