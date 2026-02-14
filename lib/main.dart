import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_experiment/core/Theme/theme.dart';
import 'package:flutter_experiment/core/network/api_client.dart';
import 'package:flutter_experiment/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_experiment/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_experiment/features/auth/presentation/screens/login_screen.dart';

void main() {
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
  final apiClient = DioApiClient(dio);
  final dataSource = AuthRemoteDatasourceImpl(apiClient: apiClient);
  final authRepo = AuthRepositoryImpl(remoteDataSource: dataSource);
  final registerUseCase = RegisterUsecaseImpl(authRepo: authRepo);

  runApp(
    BlocProvider(
      create: (_) => AuthBloc(registerUseCase),
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
      home: const LoginScreen(),
    );
  }
}
