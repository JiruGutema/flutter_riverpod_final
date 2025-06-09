import '../../../domain/models/user_model.dart';

class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final String token;

  AuthState({this.isAuthenticated = false, this.user, this.token = ''});

  AuthState copyWith({bool? isAuthenticated, UserModel? user, String? token}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}
