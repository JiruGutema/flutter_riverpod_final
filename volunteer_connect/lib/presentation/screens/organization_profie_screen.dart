// lib/presentation/screens/organization_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/profile_provider.dart';
import '../widgets/skill_chip.dart';
import '../widgets/delete_account_dialog.dart';
import 'edit_organization_profile_screen.dart';

class OrganizationProfileScreen extends ConsumerWidget {
  final int userId;

  const OrganizationProfileScreen({required this.userId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profAsync = ref.watch(profileProvider(userId));

    return profAsync.when(
      loading: () =>
      const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) =>
          Scaffold(
            body: Center(child: Text('Error: \$e')),
          ),
      data: (p) =>
          Scaffold(
            appBar: AppBar(title: const Text('Organization')),
            floatingActionButton: FloatingActionButton(
              onPressed: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditOrganizationProfileScreen(profile: p),
                    ),
                  ),
              child: const Icon(Icons.edit),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with Logo, Name & Role
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                              Icons.business, size: 50, color: Colors.blue),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p.role,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  // Information Card with Delete Button
                  Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                showDeleteAccountDialog(
                                  context: context,
                                  ref: ref,
                                  userId: p.id,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Information',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              _infoRow(Icons.email, p.email),
                              const SizedBox(height: 8),
                              _infoRow(Icons.location_on, p.city),
                              const SizedBox(height: 8),
                              _infoRow(Icons.phone, p.phone),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stats & Domains Card
                  Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Stats',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          _statRow(
                              Icons.calendar_today, p.attendedEvents, 'Events'),
                          const SizedBox(height: 16),
                          const Text(
                            'Domains',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: p.skills.map((domain) =>
                                SkillChip(label: domain)).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
    );
  }

  Widget _infoRow(IconData icon, String text) =>
      Row(
        children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(text)],
      );

  Widget _statRow(IconData icon, int value, String label) =>
      Row(
        children: [
          Icon(icon, color: const Color.fromRGBO(53, 151, 218, 1)),
          const SizedBox(width: 8),
          Text('$value', style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
}