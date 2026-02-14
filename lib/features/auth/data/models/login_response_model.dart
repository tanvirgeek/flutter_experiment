import 'package:flutter_experiment/features/auth/domain/entities/login_request.dart';
import 'package:flutter_experiment/features/auth/domain/entities/login_response.dart';

class LoginRequestModel extends LoginRequest {
  LoginRequestModel({required super.email, required super.password});

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password};
  }
}

class LoginResponseModel extends LoginResponse {
  LoginResponseModel({required super.accessToken, required super.refreshToken});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }
}
