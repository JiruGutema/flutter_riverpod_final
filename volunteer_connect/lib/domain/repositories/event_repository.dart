import '../models/event_model.dart';
import '../../infrastructure/data_sources/api_client.dart';

class EventRepository {
  Future<List<EventModel>> getAllEvents() async {
    final response = await ApiClient.get('/events', requiresAuth: true);

    final List<dynamic> eventsJson = response.data['events'];

    return eventsJson
        .map((eventJson) => EventModel.fromJson(eventJson))
        .toList();
  }
}
