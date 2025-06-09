// Future<bool> tryAutoLogin() async {
//   final token = await _secureStorage.read(key: 'auth_token');
//   final userJson = await _secureStorage.read(key: 'auth_user');

//   if (token != null && userJson != null) {
//     final userMap = jsonDecode(userJson);
//     final user = UserModel.fromJson(userMap);
//     state = state.copyWith(token: token, user: user, isAuthenticated: true);
//     return true;
//   }
//   return false;
// }
