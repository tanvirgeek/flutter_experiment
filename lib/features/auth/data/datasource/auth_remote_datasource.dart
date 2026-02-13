import 'package:flutter_experiment/core/network/api_client.dart';
import 'package:flutter_experiment/features/auth/data/models/register_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<RegisterResponseModel> register({
    required String email,
    required String password,
    required String name,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<RegisterResponseModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await apiClient.post(
      '/auth/register',
      data: {"email": email, "password": password, "name": name},
    );

    return RegisterResponseModel.fromJson(response.data);
  }
}
