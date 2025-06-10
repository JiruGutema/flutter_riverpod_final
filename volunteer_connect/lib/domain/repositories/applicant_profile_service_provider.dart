import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/infrastructure/data_sources/applicant_profile_service.dart';
import 'package:volunteer_connect/infrastructure/core/dio_provider.dart';

final applicantProfileServiceProvider = Provider<ApplicantProfileService>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return ApplicantProfileService(dio);
});
