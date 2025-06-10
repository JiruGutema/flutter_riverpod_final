import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:volunteer_connect/domain/models/applicant.dart';
import 'package:volunteer_connect/infrastructure/core/dio_provider.dart';

final applicantsProvider = FutureProvider.family<List<Applicant>, String>((
  ref,
  eventId,
) async {
  final dio = ref.watch(dioProvider); 

  try {
    final response = await dio.get('/api/event/$eventId/applicants/');
    final data = response.data as List;
    return data.map((json) => Applicant.fromJson(json)).toList();
  } on DioException catch (e) {
    throw Exception('Dio error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: $e');
  }
});
