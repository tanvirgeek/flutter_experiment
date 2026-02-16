import 'package:flutter_experiment/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:flutter_experiment/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_experiment/features/auth/data/models/login_response_model.dart';
import 'package:flutter_experiment/features/auth/data/models/logout_model.dart';
import 'package:flutter_experiment/features/auth/data/models/register_response_model.dart';
import 'package:flutter_experiment/features/auth/domain/entities/auth_tokens.dart';
import 'package:flutter_experiment/features/auth/domain/entities/login_response.dart';
import 'package:flutter_experiment/features/auth/domain/entities/register_response.dart';
import 'package:flutter_experiment/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<LoginResponse> login({required LoginRequestModel data}) async {
    final response = await remoteDataSource.login(data: data);
    await localDataSource.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return response;
  }

  @override
  Future<RegisterResponse> register({required RegisterRequestModel data}) {
    return remoteDataSource.register(data: data);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getRefreshToken();
    return token != null;
  }

  @override
  Future<AuthTokens> refreshToken({required String refreshToken}) async {
    final tokens = await remoteDataSource.refreshToken(
      refreshToken: refreshToken,
    );
    await localDataSource.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
    return tokens;
  }

  @override
  Future<LogoutResponseModel> logout({required LogoutRequestModel data}) {
    return remoteDataSource.logout(data: data);
  }
}
