import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/presentation/screens/event_applicants_screen.dart';
// import '../models/org_event.dart';
import '../widgets/event_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_chip.dart';
import 'package:volunteer_connect/application/providers/org_event_provider.dart';



class OrgEventListScreen extends ConsumerStatefulWidget {
  const OrgEventListScreen({super.key});

  @override
  ConsumerState<OrgEventListScreen> createState() => _OrgEventListScreenState();
}

class _OrgEventListScreenState extends ConsumerState<OrgEventListScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Education',
    'Seniors',
     'Environment',
      'Food',
    'Community',
    'Animals',
    'Health',
  ];


  @override
  Widget build(BuildContext context) {
    final eventsAsyncValue = ref.watch(orgEventProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Posts',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.volunteer_activism_outlined),
                ],
              ),
              const SizedBox(height: 12),
              SearchBarWidget(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, index) {
                    final category = _categories[index];
                    return CategoryChip(
                      label: category,
                      selected: _selectedCategory == category,
                      onSelected: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: eventsAsyncValue.when(
                  data: (events) {
                    final filteredEvents =
                        events.where((event) {
                          final matchesCategory =
                              _selectedCategory == 'All' ||
                              event.category == _selectedCategory;
                          final matchesSearch = event.title
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase());
                          return matchesCategory && matchesSearch;
                        }).toList();

                    if (filteredEvents.isEmpty) {
                      return const Center(child: Text("No events found."));
                    }

                    return ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        return EventCard(
                          event: filteredEvents[index],
                          onViewApplicants: (eventId) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        EventApplicantsScreen(eventId: eventId),
                              ),
                            );
                          },
                        );

                      },
                    );

                  },
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
