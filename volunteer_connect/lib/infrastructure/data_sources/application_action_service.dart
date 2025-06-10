import 'package:dio/dio.dart';

class ApplicationActionService {
  final Dio _dio;

  ApplicationActionService(this._dio);

  Future<void> approve(String eventId) async {
    await _dio.patch('/api/applications/$eventId/approve');
  }

  Future<void> reject(String eventId) async {
    await _dio.patch('/api/applications/$eventId/reject');
  }
}
