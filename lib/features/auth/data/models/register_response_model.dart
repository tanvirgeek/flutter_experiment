import 'package:flutter_experiment/features/auth/domain/entities/register_response.dart';

class RegisterResponseModel extends RegisterResponse {
  RegisterResponseModel({required super.message});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(message: json['message']);
  }
}
