import 'package:flutter_experiment/features/auth/domain/repositories/auth_repository.dart';

abstract interface class CheckAuthUseCase {
  Future<bool> call();
}

class CheckAuthUseCaseImpl implements CheckAuthUseCase {
  final AuthRepository repository;

  CheckAuthUseCaseImpl({required this.repository});

  @override
  Future<bool> call() {
    return repository.isLoggedIn();
  }
}
