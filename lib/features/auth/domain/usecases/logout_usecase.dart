import 'package:flutter_experiment/features/auth/data/models/logout_model.dart';
import 'package:flutter_experiment/features/auth/domain/repositories/auth_repository.dart';

abstract interface class LogoutUsecase {
  Future<LogoutResponseModel> call({required String? refreshToken});
}

class LogoutUsecaseImpl implements LogoutUsecase {
  final AuthRepository authRepository;

  LogoutUsecaseImpl({required this.authRepository});

  @override
  Future<LogoutResponseModel> call({required String? refreshToken}) {
    return authRepository.logout(
      data: LogoutRequestModel(refreshToken: refreshToken),
    );
  }
}
