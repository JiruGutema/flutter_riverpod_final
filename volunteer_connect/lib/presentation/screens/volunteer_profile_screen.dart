
/// lib/presentation/screens/volunteer_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/profile_provider.dart';
import '../widgets/skill_chip.dart';
import 'edit_profile_screen.dart';

class VolunteerProfileScreen extends ConsumerWidget {
  final int userId;
  const VolunteerProfileScreen({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profAsync = ref.watch(profileProvider(userId));
    return profAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: \$e'))),
      data: (p) => Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EditProfileScreen(profile: p)),
          ),
          child: const Icon(Icons.edit),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar + name + role
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                    const SizedBox(height: 12),
                    Text(p.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(p.role, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              // Personal Info
              Card(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Personal Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _infoRow(Icons.email, p.email),
                      const SizedBox(height: 8),
                      _infoRow(Icons.location_on, p.city),
                      const SizedBox(height: 8),
                      _infoRow(Icons.phone, p.phone),
                      const SizedBox(height: 12),
                      const Text('Bio', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(p.bio),
                    ],
                  ),
                ),
              ),
              // Stats
              Card(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Volunteer Stats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _statItem(Icons.calendar_today, p.attendedEvents.toString(), 'Events Attended'),
                          const SizedBox(width: 32),
                          _statItem(Icons.access_time, p.hoursVolunteered.toString(), 'Hours Volunteered'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Skills', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, children: p.skills.map((s) => SkillChip(label: s)).toList()),
                      const SizedBox(height: 16),
                      const Text('Interests', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, children: p.interests.map((i) => SkillChip(label: i)).toList()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Row(
    children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(text)],
  );
  Widget _statItem(IconData icon, String value, String label) => Row(
    children: [Icon(icon), const SizedBox(width: 8), Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text(label)],
    )],
  );
}