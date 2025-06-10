import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/infrastructure/data_sources/org_event_api_service.dart';
import 'package:volunteer_connect/infrastructure/core/dio_provider.dart';

final orgEventApiServiceProvider = Provider<OrgEventApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return OrgEventApiService(dio);
});
