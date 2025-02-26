class LoginResponse {
  final int userId;
  final String token;
  final String refreshToken;

  LoginResponse(
      {required this.userId, required this.token, required this.refreshToken});
}
