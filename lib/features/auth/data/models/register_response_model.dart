import 'package:flutter_experiment/features/auth/domain/entities/register_response.dart';

class RegisterResponseModel extends RegisterResponse {
  RegisterResponseModel({required super.message});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(message: json['message']);
  }
}

class RegisterRequestModel extends RegisterRequestDto {
  RegisterRequestModel({
    required super.email,
    required super.password,
    required super.name,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'name': name};
  }
}
