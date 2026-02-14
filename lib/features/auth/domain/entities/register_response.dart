class RegisterResponse {
  final String message;
  RegisterResponse({required this.message});
}


class RegisterRequestDto {
  final String email;
  final String password;
  final String name;

  RegisterRequestDto({required this.email, required this.password, required this.name});
}
