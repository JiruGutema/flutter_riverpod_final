import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/application/providers/auth_provider.dart';
import 'package:volunteer_connect/application/providers/org_event_provider.dart';
import 'package:volunteer_connect/domain/models/org_event.dart';
import 'package:volunteer_connect/presentation/screens/login_screen.dart';
import 'package:volunteer_connect/presentation/screens/org_event.dart';
import 'package:volunteer_connect/presentation/screens/volunteer_home.dart';

class OrganizationHomePage extends ConsumerStatefulWidget {
  const OrganizationHomePage({super.key});

  @override
  ConsumerState<OrganizationHomePage> createState() =>
      _OrganizationHomePageState();
}

class _OrganizationHomePageState extends ConsumerState<OrganizationHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    OrgStyledHomeScreen(), // Styled like volunteer's home
    OrgEventListScreen(), // List of org's posted events
    ProfilePage(), // Organization's profile
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
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'My Events'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class OrgStyledHomeScreen extends ConsumerWidget {
  const OrgStyledHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(orgEventProvider);

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

                /// Header with Logout
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Welcome back, Org!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("Here are your current activities."),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// Ongoing Event
                const Text(
                  "Ongoing",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _OngoingEventCard(event: ongoingEvent),

                const SizedBox(height: 24),

                /// Upcoming Events
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Upcoming Events",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("View all", style: TextStyle(color: Colors.blue)),
                  ],
                ),
                const SizedBox(height: 12),
                ...upcomingEvents.map(
                  (event) => _UpcomingEventCard(event: event),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OngoingEventCard extends StatelessWidget {
  final OrgEvent event;
  const _OngoingEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage('assets/image.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.bottomLeft,
      child: Text(
        'Don’t miss your "${event.title}" event!',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _UpcomingEventCard extends StatelessWidget {
  final OrgEvent event;
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
            'assets/image.png',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
