import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_experiment/core/network/api_client.dart';
import 'package:flutter_experiment/core/network/dio_interceptor.dart';
import 'package:flutter_experiment/features/blogs/data/datasource/blog_remote_datasource.dart';
import 'package:flutter_experiment/features/blogs/data/repositories/blogs_repository.dart';
import 'package:flutter_experiment/features/blogs/domain/usecases/blogs_usecase.dart';
import 'package:flutter_experiment/features/blogs/domain/usecases/create_blog_usecase.dart';
import 'package:flutter_experiment/features/blogs/domain/usecases/delete_blog_usecase.dart';
import 'package:flutter_experiment/features/blogs/presentation/bloc/blogs_bloc.dart';
import 'package:flutter_experiment/features/blogs/presentation/screens/blogs_screen.dart';
import 'package:flutter_experiment/features/shared/screens/settings.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create dependencies ONCE here
    final Dio dio = DioSingleton().dio;
    final apiClient = DioApiClient(dio);

    final blogRemoteDataSource = BlogRemoteDataSourceImpl(apiClient);

    final blogRepository = BlogRepositoryImpl(blogRemoteDataSource);

    final getBlogsUseCase = GetBlogsUseCaseImpl(blogRepository);
    final createBlogUseCase = CreateBlogUseCaseImpl(blogRepository);
    final deleteBlogUseCase = DeleteBlogUsecaseImpl(repository: blogRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BlogBloc(
            getBlogsUseCase: getBlogsUseCase,
            createBlogUseCase: createBlogUseCase,
            deleteBlogUseCase: deleteBlogUseCase,
          ),
        ),
      ],
      child: _BottomNavBody(),
    );
  }
}

class _BottomNavBody extends StatefulWidget {
  const _BottomNavBody();

  @override
  State<_BottomNavBody> createState() => _BottomNavBodyState();
}

class _BottomNavBodyState extends State<_BottomNavBody> {
  int _currentIndex = 0;

  final List<Widget> _screens = [BlogsScreen(), Text("Offline"), Settings()];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: "Blogs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_outlined),
            label: "Offline",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
