abstract class AuthEvent {}

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

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}
