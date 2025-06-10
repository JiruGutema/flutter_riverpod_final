import 'dart:math';
import 'package:flutter/material.dart';
import 'package:volunteer_connect/domain/models/org_event.dart';

final _random = Random();
final _fallbackImages = [
  'assets/img/event_three.jpg',
  'assets/img/event_four.jpg',
  'assets/img/event_five.jpg',
  'assets/img/event_six.jpg',
];

class EventCard extends StatelessWidget {
  final OrgEvent event;
  final void Function(String eventId) onViewApplicants;

  const EventCard({
    super.key,
    required this.event,
    required this.onViewApplicants,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child:
                event.image != null
                    ? Image.network(
                      event.image!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    )
                    : Image.asset(
                      _fallbackImages[_random.nextInt(_fallbackImages.length)],
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(event.subtitle, style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 12),
                _InfoRow(icon: Icons.calendar_today, text: event.date),
                if (event.time != null)
                  _InfoRow(icon: Icons.access_time, text: event.time!),
                _InfoRow(icon: Icons.location_on, text: event.location),
                _InfoRow(
                  icon: Icons.group,
                  text: 'Spots left: ${event.spotsLeft}',
                ),
                const SizedBox(height: 12),
                Center(
                  child: ElevatedButton(
                  onPressed: () => onViewApplicants(event.id.toString()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3597da),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'View Applicants',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF3597da)),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
