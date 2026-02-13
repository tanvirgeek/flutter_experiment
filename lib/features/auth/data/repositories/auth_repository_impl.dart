import 'package:flutter_experiment/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_experiment/features/auth/domain/entities/register_response.dart';
import 'package:flutter_experiment/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<RegisterResponse> register({
    required String name,
    required String email,
    required String password,
  }) {
    return remoteDataSource.register(
      email: email,
      password: password,
      name: name,
    );
  }
}
