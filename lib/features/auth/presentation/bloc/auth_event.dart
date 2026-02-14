abstract class AuthEvent {}

/// Triggered when user registers
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });
}

/// Triggered when user logs in
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

/// Triggered when checking authentication status (e.g., SplashScreen)
class CheckAuthStatusEvent extends AuthEvent {}

/// Triggered when we want to refresh access token
class RefreshTokenEvent extends AuthEvent {
  final String refreshToken;

  RefreshTokenEvent({required this.refreshToken});
}
