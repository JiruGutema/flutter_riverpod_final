import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/application/providers/application_provider.dart';
import 'package:volunteer_connect/domain/models/application_model.dart';
import 'package:volunteer_connect/infrastructure/data_sources/api_client.dart';

class MyApplicationsScreen extends ConsumerStatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  ConsumerState<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends ConsumerState<MyApplicationsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final appsAsync = ref.watch(applicationProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'My Application',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildFilterChips(),
            Expanded(
              child: appsAsync.when(
                data: (apps) {
                  final filtered = _selectedFilter == 'All'
                      ? apps
                      : apps.where((a) => a.status == _selectedFilter).toList();

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _ApplicationCard(
                        application: filtered[index],
                        onCancel: _handleCancel,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    const filters = ['All', 'Pending', 'Approved', 'Other'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(f),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedFilter = f),
              selectedColor: Colors.blue,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _handleCancel(ApplicationModel app) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Application'),
        content: const Text('Are you sure you want to cancel this application?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ApiClient.delete('/applications/${app.id}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Application canceled.'),
        ));
        ref.refresh(applicationProvider); // Refresh list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to cancel: $e'),
        ));
      }
    }
  }
}


class _ApplicationCard extends StatelessWidget {
  final ApplicationModel application;
  final void Function(ApplicationModel) onCancel;

  const _ApplicationCard({
    required this.application,
    required this.onCancel,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Canceled':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Approved':
        return Icons.check_circle;
      case 'Pending':
        return Icons.access_time;
      case 'Canceled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_statusIcon(application.status), color: _statusColor(application.status)),
                const SizedBox(width: 4),
                Text(application.status, style: TextStyle(color: _statusColor(application.status))),
                const Spacer(),
                Text('Applied on ${application.date}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Text(application.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (application.title.isNotEmpty) Text(application.title),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text(application.date),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(application.time ?? 'N/A'),
              ],
            ),
            Text('Category: ${application.organization}'),
            if (application.status == 'Pending')
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  label: const Text('Cancel', style: TextStyle(color: Colors.red)),
                  onPressed: () => onCancel(application),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
