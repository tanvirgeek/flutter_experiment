import 'package:flutter_experiment/features/auth/data/models/login_response_model.dart';
import 'package:flutter_experiment/features/auth/domain/entities/login_response.dart';
import 'package:flutter_experiment/features/auth/domain/repositories/auth_repository.dart';

abstract interface class LoginUsecase {
  Future<LoginResponse> call({required String email, required String password});
}

class LoginUsecaseImpl implements LoginUsecase {
  final AuthRepository authRepository;

  LoginUsecaseImpl({required this.authRepository});

  @override
  Future<LoginResponse> call({
    required String email,
    required String password,
  }) {
    return authRepository.login(
      data: LoginRequestModel(email: email, password: password),
    );
  }
}
