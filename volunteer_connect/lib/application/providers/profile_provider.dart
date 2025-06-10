/// lib/application/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/profile_repository_impl.dart';
import '../../infrastructure/data_sources/profile_data_source.dart';
import '../../domain/models/profile_model.dart';

final profileDataSourceProvider = Provider((ref) => ProfileDataSource());
final profileRepositoryProvider = Provider<ProfileRepositoryImpl>((ref) {
  return ProfileRepositoryImpl(ref.read(profileDataSourceProvider));
});
final profileProvider = FutureProvider.family<Profile, int>((ref, userId) async {
  return await ref.read(profileRepositoryProvider).getProfile(userId);
});
