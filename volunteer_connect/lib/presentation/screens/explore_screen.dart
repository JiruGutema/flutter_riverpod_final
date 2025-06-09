import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/application/providers/auth_provider.dart';
import 'package:volunteer_connect/application/providers/event_provider.dart';
import 'package:volunteer_connect/domain/models/event_model.dart';
import 'package:volunteer_connect/infrastructure/data_sources/api_client.dart';
import 'package:volunteer_connect/presentation/screens/event_detail_page.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Explore Events')),
      body: eventsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return const Center(child: Text('No events available.'));
          }
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/image.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Title: ${event.title}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Subtitle: ${event.subtitle}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Date: ${event.date}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Time: ${event.time}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Catagory ${event.category}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        event.spotsLeft > 0
                            ? '${event.spotsLeft} spots left'
                            : 'No spots left',
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.center,

                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                          ),

                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EventDetailPage(event: event),
                                ),
                              ),
                          child: const Text('Detail', style: TextStyle(color: Colors.white),)
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
