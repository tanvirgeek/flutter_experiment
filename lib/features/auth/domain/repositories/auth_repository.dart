import 'package:flutter_experiment/features/auth/data/models/register_response_model.dart';
import 'package:flutter_experiment/features/auth/domain/entities/register_response.dart';

abstract interface class AuthRepository {
  Future<RegisterResponse> register({required RegisterRequestModel data});
}
