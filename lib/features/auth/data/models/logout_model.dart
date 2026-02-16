class LogoutRequestModel {
  final String? refreshToken;

  LogoutRequestModel({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      "refreshToken": refreshToken,
    };
  }
}

class LogoutResponseModel {
  final String message;

  LogoutResponseModel({
    required this.message,
  });

  factory LogoutResponseModel.fromJson(
      Map<String, dynamic> json) {
    return LogoutResponseModel(
      message: json["message"] ?? "",
    );
  }
}

