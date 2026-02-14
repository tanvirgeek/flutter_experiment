import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_experiment/core/Theme/theme.dart';
import 'package:flutter_experiment/core/network/api_client.dart';
import 'package:flutter_experiment/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:flutter_experiment/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_experiment/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_experiment/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_experiment/features/blogs/presentation/screens/blogs_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
  final apiClient = DioApiClient(dio);
  final dataSource = AuthRemoteDatasourceImpl(apiClient: apiClient);
  const secureStorage = FlutterSecureStorage();
  final localDataSource = AuthLocalDataSourceImpl(secureStorage: secureStorage);
  final authRepo = AuthRepositoryImpl(
    remoteDataSource: dataSource,
    localDataSource: localDataSource,
  );
  final registerUseCase = RegisterUsecaseImpl(authRepo: authRepo);
  final loginUsecase = LoginUsecaseImpl(authRepository: authRepo);
  final checkAuthUseCase = CheckAuthUseCaseImpl(repository: authRepo);

  runApp(
    BlocProvider(
      create: (_) => AuthBloc(
        loginUsecase: loginUsecase,
        registerUseCase: registerUseCase,
        checkAuthUseCase: checkAuthUseCase,
      )..add(CheckAuthStatusEvent()),
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

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthenticatedState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const BlogsScreen()),
            );
          }

          if (state is UnauthenticatedState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
