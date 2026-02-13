import 'package:flutter_experiment/features/auth/domain/entities/register_response.dart';
import 'package:flutter_experiment/features/auth/domain/repositories/auth_repository.dart';

abstract interface class RegisterUsecase {
  Future<RegisterResponse> call({
    required String email,
    required String password,
    required String name,
  });
}

class RegisterUsecaseImpl implements RegisterUsecase {
  final AuthRepository authRepo;

  RegisterUsecaseImpl({required this.authRepo});

  @override
  Future<RegisterResponse> call({
    required String email,
    required String password,
    required String name,
  }) {
    return authRepo.register(name: name, email: email, password: password);
  }
}
