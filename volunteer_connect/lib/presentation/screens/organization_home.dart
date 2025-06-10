import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/application/providers/auth_provider.dart';
import 'package:volunteer_connect/presentation/screens/login_screen.dart';
import 'package:volunteer_connect/presentation/screens/profile_screen.dart';
import '../../../application/providers/event_provider.dart';
import '../../../domain/models/event_model.dart';

class OrganizationHomePage extends ConsumerStatefulWidget {
  const OrganizationHomePage({super.key});

  @override
  ConsumerState<OrganizationHomePage> createState() =>
      _OrganizationHomePageState();
}

class _OrganizationHomePageState extends ConsumerState<OrganizationHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _EventsList(),
    Center(child: Text('Explore Page')),
    Center(child: Text('My Application Page')),
    Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'My Applications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Profile'),
        ],
      ),
    );
  }
}

class _EventsList extends ConsumerWidget {
  const _EventsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return const Center(child: Text('No events available.'));
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return EventCard(event: event);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventModel event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              event.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(event.subtitle, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text('${event.date} at ${event.time}'),
            Text('Location: ${event.location}'),
            Text('Spots left: ${event.spotsLeft}'),
            const SizedBox(height: 4),
            Text(event.description),
          ],
        ),
      ),
    );
  }
}
