import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_experiment/core/network/api_client.dart';
import 'package:flutter_experiment/core/network/dio_interceptor.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_experiment/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_experiment/features/blogs/data/datasource/blog_remote_datasource.dart';
import 'package:flutter_experiment/features/blogs/data/repositories/blogs_repository.dart';
import 'package:flutter_experiment/features/blogs/domain/usecases/blogs_usecase.dart';
import 'package:flutter_experiment/features/blogs/presentation/bloc/blogs_bloc.dart';
import 'package:flutter_experiment/features/blogs/presentation/screens/blogs_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthenticatedState) {
            final dio = DioSingleton().dio;
            final apiClient = DioApiClient(dio);
            final remoteDataSource = BlogRemoteDataSourceImpl(apiClient);
            final repository = BlogRepositoryImpl(remoteDataSource);
            final getBlogsUseCase = GetBlogsUseCaseImpl(repository);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => BlogBloc(getBlogsUseCase),
                  child: const BlogsScreen(),
                ),
              ),
            );
          } else if (state is UnauthenticatedState) {
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
