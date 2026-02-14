import 'package:flutter_experiment/features/auth/domain/entities/auth_tokens.dart';
import 'package:flutter_experiment/features/auth/domain/repositories/auth_repository.dart';

abstract interface class RefreshTokenUsecase {
  Future<AuthTokens> call({required String refreshToken});
}

class RefreshTokenUsecaseImpl implements RefreshTokenUsecase {
  final AuthRepository repository;

  RefreshTokenUsecaseImpl({required this.repository});

  @override
  Future<AuthTokens> call({required String refreshToken}) {
    return repository.refreshToken(refreshToken: refreshToken);
  }
}
