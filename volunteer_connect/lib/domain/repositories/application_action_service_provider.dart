import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/infrastructure/data_sources/application_action_service.dart';
import 'package:volunteer_connect/infrastructure/core/dio_provider.dart';

final applicationActionServiceProvider = Provider<ApplicationActionService>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return ApplicationActionService(dio);
});
