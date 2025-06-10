import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/application/states/auth_state.dart';
import '../../../domain/models/user_model.dart';
import '../../../infrastructure/storage/secure_storage.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await SecureStorage.getToken();
    final userJson = await SecureStorage.getUser();

    if (token != null && userJson != null) {
      final userMap = jsonDecode(userJson);
      final user = UserModel.fromJson(userMap);
      state = state.copyWith(isAuthenticated: true, token: token, user: user);
    }
  }

  Future<void> login(String token, Map<String, dynamic> userJson) async {
    final user = UserModel.fromJson(userJson);

    await SecureStorage.saveToken(token);
    await SecureStorage.saveUser(jsonEncode(user.toJson()));

    state = state.copyWith(
      isAuthenticated: true,
      user: user,
      token: token,
    );
  }

  Future<void> logout() async {
    await SecureStorage.clearAll();
    state = AuthState(); // reset state
  }

Future<UserModel?> tryAutoLogin() async {
    final token = await SecureStorage.getToken();
    final userJson = await SecureStorage.getUser();

    if (token != null && userJson != null) {
      final userMap = jsonDecode(userJson);
      final user = UserModel.fromJson(userMap);
print('Loaded user role from storage: ${user.role}');
      state = state.copyWith(token: token, user: user, isAuthenticated: true);
      return user;
    }

    return null;
  }

}
