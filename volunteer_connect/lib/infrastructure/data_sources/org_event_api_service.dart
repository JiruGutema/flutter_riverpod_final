import 'package:dio/dio.dart';
import 'package:volunteer_connect/domain/models/org_event.dart';
class OrgEventApiService {
  final Dio _dio;

  OrgEventApiService(this._dio);

  Future<List<OrgEvent>> fetchOrgEvents() async {
    try {
      final response = await _dio.get('/api/events/org');


      final List<dynamic> eventsJson = response.data['events'];
      return eventsJson.map((json) => OrgEvent.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load org events: $e');
    }
  }
}
