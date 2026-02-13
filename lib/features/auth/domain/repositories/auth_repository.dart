import 'package:flutter_experiment/features/auth/domain/entities/register_response.dart';

abstract interface class AuthRepository {
  Future<RegisterResponse> register({
    required String name,
    required String email,
    required String password,
  });
}
