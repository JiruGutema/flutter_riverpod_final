import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/domain/models/org_event.dart';
import 'package:volunteer_connect/domain/repositories/org_event_api_service_provider.dart';
final orgEventProvider = FutureProvider<List<OrgEvent>>((ref) async {
  final apiService = ref.watch(orgEventApiServiceProvider);
  return apiService.fetchOrgEvents();
});
