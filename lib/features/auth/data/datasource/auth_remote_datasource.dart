import 'package:flutter_experiment/core/error/exceptions.dart';
import 'package:flutter_experiment/core/network/api_client.dart';
import 'package:flutter_experiment/features/auth/data/models/login_response_model.dart';
import 'package:flutter_experiment/features/auth/data/models/register_response_model.dart';
import 'package:flutter_experiment/features/auth/domain/entities/auth_tokens.dart';

abstract interface class AuthRemoteDataSource {
  Future<RegisterResponseModel> register({required RegisterRequestModel data});
  Future<LoginResponseModel> login({required LoginRequestModel data});
  Future<AuthTokens> refreshToken({required String refreshToken});
}

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<RegisterResponseModel> register({
    required RegisterRequestModel data,
  }) async {
    final response = await apiClient.post(
      '/auth/register',
      data: data.toJson(),
    );
    return RegisterResponseModel.fromJson(response.data);
  }

  @override
  Future<LoginResponseModel> login({required LoginRequestModel data}) async {
    final response = await apiClient.post(
      "/auth/login",
      data: data.toJson(),
    );
    return LoginResponseModel.fromJson(response.data);
  }

  @override
  Future<AuthTokens> refreshToken({required String refreshToken}) async {
    final response = await apiClient.post("/auth/refresh", data: {
      "refreshToken": refreshToken,
    });

    if (response.data["accessToken"] == null || response.data["refreshToken"] == null) {
      throw ServerException("Invalid refresh response");
    }

    return AuthTokens(
      accessToken: response.data["accessToken"],
      refreshToken: response.data["refreshToken"],
    );
  }
}

