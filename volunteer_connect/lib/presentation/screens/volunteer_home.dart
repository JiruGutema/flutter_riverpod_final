
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/application/providers/auth_provider.dart';
import 'package:volunteer_connect/application/providers/event_provider.dart';
import 'package:volunteer_connect/domain/models/event_model.dart';
import 'package:volunteer_connect/presentation/screens/explore_screen.dart';
import 'package:volunteer_connect/presentation/screens/login_screen.dart';
import 'package:volunteer_connect/presentation/screens/my_application_screen.dart';

class VolunteerHomePage extends ConsumerStatefulWidget {
  const VolunteerHomePage({super.key});

  @override
  ConsumerState<VolunteerHomePage> createState() => _VolunteerHomePageState();
}

class _VolunteerHomePageState extends ConsumerState<VolunteerHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreenStyledContent(), // Your new styled homepage
    ExploreScreen(),
    MyApplicationsScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Application'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/// Styled Home Screen
class HomeScreenStyledContent extends ConsumerWidget {
  const HomeScreenStyledContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: eventsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
          data: (events) {
            if (events.isEmpty) {
              return const Center(child: Text('No events available.'));
            }

            final ongoingEvent = events.first;
            final upcomingEvents = events.skip(1).toList();

            return ListView(
              children: [
                const SizedBox(height: 16),

                /// Header with logout
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Hello, John",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("Ready to make a difference today?"),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
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

                const SizedBox(height: 24),

                /// Ongoing Event Card
                const Text("Ongoing", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _OngoingEventCard(event: ongoingEvent),

                const SizedBox(height: 24),

                /// Upcoming Events Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Upcoming events",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("View all", style: TextStyle(color: Colors.blue)),
                  ],
                ),

                const SizedBox(height: 12),

                /// Upcoming Events List
                ...upcomingEvents.map((event) => _UpcomingEventCard(event: event)),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Ongoing Event UI Card
class _OngoingEventCard extends StatelessWidget {
  final EventModel event;
  const _OngoingEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage('assets/image.png'), // Replace with NetworkImage(event.image) if needed
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
        ),
      ),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.bottomLeft,
      child: Text(
        'Join us at the ${event.title} Event.',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Upcoming Event Card
class _UpcomingEventCard extends StatelessWidget {
  final EventModel event;
  const _UpcomingEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/image.png', // Replace with NetworkImage(event.image) if applicable
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.subtitle),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14),
                const SizedBox(width: 4),
                Text('${event.date}, ${event.time}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder Profile Page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Page'));
  }
}
