abstract class AuthState {}

/// Initial state
class AuthInitial extends AuthState {}

/// Loading state (register/login/refresh)
class AuthLoading extends AuthState {}

/// Registration success
class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}

/// Any failure (server, network)
class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

/// Login success
class LoginSuccess extends AuthState {}

/// User authenticated via refresh token
class AuthenticatedState extends AuthState {}

/// User not authenticated / token invalid
class UnauthenticatedState extends AuthState {}

/// Tokens refreshed successfully
class TokenRefreshedState extends AuthState {
  final String accessToken;
  final String refreshToken;

  TokenRefreshedState({required this.accessToken, required this.refreshToken});
}
