import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/application/providers/applicant_profile_provider.dart';
import 'package:volunteer_connect/domain/repositories/application_action_service_provider.dart';

class ApplicantProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  final String eventId;
  final String status;

  const ApplicantProfileScreen({
    super.key,
    required this.userId,
    required this.eventId,
    required this.status,
  });

  @override
  ConsumerState<ApplicantProfileScreen> createState() =>
      _ApplicantProfileScreenState();
}

class _ApplicantProfileScreenState
    extends ConsumerState<ApplicantProfileScreen> {
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    final applicantAsync = ref.watch(applicantProfileProvider(widget.userId));
    final actionService = ref.watch(applicationActionServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        // title: const Text('Applicant Profile'),
          title: Text('Applicant Profile (${widget.userId})'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: applicantAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (applicant) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Card
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      color: Colors.white,
                      shadowColor: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 28,
                          horizontal: 24,
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.account_circle,
                              size: 68,
                              color: Color.fromARGB(255, 20, 20, 20),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              applicant.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: [
                                const Text(
                                  'Volunteer',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        currentStatus == 'approved'
                                            ? Colors.green[100]
                                            : currentStatus == 'rejected'
                                            ? Colors.red[100]
                                            : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    currentStatus.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          currentStatus == 'approved'
                                              ? Colors.green[800]
                                              : currentStatus == 'rejected'
                                              ? Colors.red[800]
                                              : Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Personal Info Card
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      color: Colors.white,
                      shadowColor: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Personal Information',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 28, thickness: 1.3),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.email_outlined,
                                color: Color(0xFF3597DA),
                              ),
                              title: Text(
                                applicant.email,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFF3597DA),
                              ),
                              title: Text(
                                applicant.city,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.phone_outlined,
                                color: Color(0xFF3597DA),
                              ),
                              title: Text(
                                applicant.phone,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Bio',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              applicant.bio.isNotEmpty
                                  ? applicant.bio
                                  : 'No bio available',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Stats Card
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      color: Colors.white,
                      shadowColor: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Volunteer Stats',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 28, thickness: 1.3),
                            const Text(
                              'Skills',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              runSpacing: 8,
                              children:
                                  applicant.skills.isNotEmpty
                                      ? applicant.skills.map((skill) {
                                        return Chip(
                                          label: Text(
                                            skill,
                                            style: const TextStyle(
                                              color: Color(0xFF3597DA),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          backgroundColor: const Color(
                                            0xFFD7EAF8,
                                          ),
                                          elevation: 4,
                                          shadowColor: Colors.black26,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                        );
                                      }).toList()
                                      : const [
                                        Text(
                                          'No skills listed',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                            ),
                            const SizedBox(height: 28),
                            const Text(
                              'Interests',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              runSpacing: 8,
                              children:
                                  applicant.interests.isNotEmpty
                                      ? applicant.interests.map((interest) {
                                        return Chip(
                                          label: Text(
                                            interest,
                                            style: const TextStyle(
                                              color: Color(0xFF3597DA),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          backgroundColor: const Color(
                                            0xFFD7EAF8,
                                          ),
                                          elevation: 4,
                                          shadowColor: Colors.black26,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                        );
                                      }).toList()
                                      : const [
                                        Text(
                                          'No interests listed',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                            ),
                            const SizedBox(height: 30),

                            // Action Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () async {
                                    try {
                                      await actionService.approve(
                                        widget.eventId,
                                      );
                                      ref.invalidate(
                                        applicantProfileProvider(widget.userId),
                                      );
                                      setState(() {
                                        currentStatus = 'approved';
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Application Approved'),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Approval failed: $e'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Approve',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () async {
                                    try {
                                      await actionService.reject(
                                        widget.eventId,
                                      );
                                      ref.invalidate(
                                        applicantProfileProvider(widget.userId),
                                      );
                                      setState(() {
                                        currentStatus = 'rejected';
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Application Rejected'),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Rejection failed: $e'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Reject',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
