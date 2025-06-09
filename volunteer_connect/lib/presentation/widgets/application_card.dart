// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:volunteer_connect/domain/models/application_model.dart';

// class _ApplicationCard extends StatelessWidget {
//   final ApplicationModel application;
//   final void Function(ApplicationModel) onCancel;

//   const _ApplicationCard({
//     required this.application,
//     required this.onCancel,
//   });

//   Color _statusColor(String status) {
//     switch (status) {
//       case 'Approved':
//         return Colors.green;
//       case 'Pending':
//         return Colors.orange;
//       case 'Canceled':
//         return Colors.grey;
//       default:
//         return Colors.black;
//     }
//   }

//   IconData _statusIcon(String status) {
//     switch (status) {
//       case 'Approved':
//         return Icons.check_circle;
//       case 'Pending':
//         return Icons.access_time;
//       case 'Canceled':
//         return Icons.cancel;
//       default:
//         return Icons.help;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(12),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(_statusIcon(application.status), color: _statusColor(application.status)),
//                 const SizedBox(width: 4),
//                 Text(application.status, style: TextStyle(color: _statusColor(application.status))),
//                 const Spacer(),
//                 Text('Applied on ${application.appliedAt}', style: const TextStyle(color: Colors.grey)),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(application.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             if (application.subtitle.isNotEmpty) Text(application.subtitle),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 const Icon(Icons.calendar_today, size: 16),
//                 const SizedBox(width: 4),
//                 Text(application.date),
//                 const SizedBox(width: 16),
//                 const Icon(Icons.access_time, size: 16),
//                 const SizedBox(width: 4),
//                 Text(application.time ?? 'N/A'),
//               ],
//             ),
//             Text('Category: ${application.category}'),
//             if (application.status == 'Pending')
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton.icon(
//                   icon: const Icon(Icons.cancel, color: Colors.red),
//                   label: const Text('Cancel', style: TextStyle(color: Colors.red)),
//                   onPressed: () => onCancel(application),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
