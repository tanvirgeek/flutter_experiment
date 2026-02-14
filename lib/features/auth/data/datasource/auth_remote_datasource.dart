import 'package:flutter_experiment/core/network/api_client.dart';
import 'package:flutter_experiment/features/auth/data/models/register_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<RegisterResponseModel> register({required RegisterRequestModel data});
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
      data: {"email": data.email, "password": data.password, "name": data.name},
    );

    return RegisterResponseModel.fromJson(response.data);
  }
}
