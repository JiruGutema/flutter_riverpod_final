import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/profile_model.dart';

class ProfileDataSource {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:5500/api',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  Future<String?> _getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'auth_token');
  }

  Future<Profile> fetchProfile(int userId) async {
    final token = await _getToken();
    final resp = await _dio.get(
      '/users/$userId/profile',
      options: Options(headers: { 'Authorization': 'Bearer $token' }),
    );
    return Profile.fromJson(resp.data['user'] as Map<String, dynamic>);
  }

  Future<Profile> updateProfile(int userId, Profile updated) async {
    final token = await _getToken();
    final resp = await _dio.put(
      '/users/$userId',
      data: updated.toJson(),
      options: Options(headers: { 'Authorization': 'Bearer $token' }),
    );
    return Profile.fromJson(resp.data['user']);
  }

  /// **FIXED**: call the backend’s `DELETE /user` endpoint (no `:id` in path)
  Future<void> deleteProfile(int userId) async {
    final token = await _getToken();
    await _dio.delete(
      '/user',
      options: Options(headers: {
        'Authorization': 'Bearer $token'
      }),
    );
  }
}
