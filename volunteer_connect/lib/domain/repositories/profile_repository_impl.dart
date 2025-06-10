// lib/application/repositories/profile_repository_impl.dart
import '../../domain/models/profile_model.dart';
import '../../infrastructure/data_sources/profile_data_source.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile(int userId);
  Future<Profile> updateProfile(int userId, Profile profile);
  Future<void> deleteProfile(int userId);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource dataSource;
  ProfileRepositoryImpl(this.dataSource);

  @override
  Future<Profile> getProfile(int userId) => dataSource.fetchProfile(userId);

  @override
  Future<Profile> updateProfile(int userId, Profile profile) =>
      dataSource.updateProfile(userId, profile);

  @override
  Future<void> deleteProfile(int userId) => dataSource.deleteProfile(userId);
}