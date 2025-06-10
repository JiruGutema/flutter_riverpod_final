import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/presentation/screens/applicant_profile.dart';
import 'package:volunteer_connect/presentation/widgets/search_bar.dart';
import 'package:volunteer_connect/application/providers/applicants_provider.dart';



class EventApplicantsScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventApplicantsScreen({super.key, required this.eventId});

  @override
  ConsumerState<EventApplicantsScreen> createState() =>
      _EventApplicantsScreenState();
}

class _EventApplicantsScreenState extends ConsumerState<EventApplicantsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final applicantsAsync = ref.watch(applicantsProvider(widget.eventId));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      appBar: AppBar(
        title: const Text('Applicants'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: applicantsAsync.when(
        data: (applicants) {
          if (applicants.isEmpty) {
            return const Center(child: Text('No applicants found.'));
          }

          final filteredApplicants =
              applicants
                  .where(
                    (a) => a.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
                  )
                  .toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Applicants Header (unchanged)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Applicants',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      filteredApplicants.length.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Search Bar
                SearchBarWidget(
                  hintText: 'Search applicants...',
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // List or No Match
                if (filteredApplicants.isEmpty)
                  const Center(child: Text("No applicants match your search."))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredApplicants.length,
                      itemBuilder: (context, index) {
                        final applicant = filteredApplicants[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFF3597DA),
                                child: Text(
                                  applicant.name.isNotEmpty
                                      ? applicant.name[0]
                                      : '?',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  applicant.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => ApplicantProfileScreen(
                                            eventId: widget.eventId,
                                            userId: applicant.userId.toString(),
                                            status:
                                                applicant
                                                    .status, 
                                          ),
                                    ),
                                  );
                                },

                                icon: const Icon(
                                  Icons.article_outlined,
                                  size: 18,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  "View Applicant",
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, _) => Center(
              child: Text('Error: $err', style: TextStyle(color: Colors.red)),
            ),
      ),
    );
  }
}
