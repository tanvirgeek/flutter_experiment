import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_experiment/core/Theme/theme.dart';
import 'package:flutter_experiment/core/network/api_client.dart';
import 'package:flutter_experiment/core/network/dio_interceptor.dart';
import 'package:flutter_experiment/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:flutter_experiment/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_experiment/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_experiment/features/shared/screens/splash_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  final dio = DioSingleton().dio;
  final apiClient = DioApiClient(dio);

  const secureStorage = FlutterSecureStorage();
  final localDataSource = AuthLocalDataSourceImpl(secureStorage: secureStorage);
  final authRepo = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDatasourceImpl(apiClient: apiClient),
    localDataSource: localDataSource,
  );

  // Usecases
  final registerUseCase = RegisterUsecaseImpl(authRepo: authRepo);
  final loginUsecase = LoginUsecaseImpl(authRepository: authRepo);
  final checkAuthUseCase = CheckAuthUseCaseImpl(repository: authRepo);
  final refreshTokenUseCase = RefreshTokenUsecaseImpl(repository: authRepo);

  // Add interceptor for auto token refresh
  dio.interceptors.add(
    AuthInterceptor(
      localDataSource: localDataSource,
      refreshTokenUseCase: refreshTokenUseCase,
      dio: dio,
    ),
  );

  runApp(
    BlocProvider(
      create: (_) => AuthBloc(
        loginUsecase: loginUsecase,
        registerUseCase: registerUseCase,
        checkAuthUseCase: checkAuthUseCase,
        refreshTokenUsecase: refreshTokenUseCase,
        localDataSource: localDataSource,
      )..add(CheckAuthStatusEvent()), // Immediately check auth on app start
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
