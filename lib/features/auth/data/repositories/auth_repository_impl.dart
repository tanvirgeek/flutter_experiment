import 'package:flutter_experiment/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_experiment/features/auth/data/models/login_response_model.dart';
import 'package:flutter_experiment/features/auth/data/models/register_response_model.dart';
import 'package:flutter_experiment/features/auth/domain/entities/login_response.dart';
import 'package:flutter_experiment/features/auth/domain/entities/register_response.dart';
import 'package:flutter_experiment/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<RegisterResponse> register({required RegisterRequestModel data}) {
    return remoteDataSource.register(data: data);
  }

  @override
  Future<LoginResponse> login({required LoginRequestModel data}) {
    return remoteDataSource.login(data: data);
  }
}
