import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/event_repository.dart';
import '../../domain/models/event_model.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

final eventsProvider = FutureProvider<List<EventModel>>((ref) async {
  final repo = ref.watch(eventRepositoryProvider);
  return await repo.getAllEvents();
});
