import 'package:flutter_experiment/features/blogs/data/datasource/blog_remote_datasource.dart';
import 'package:flutter_experiment/features/blogs/data/models/blog_model.dart';
import 'package:flutter_experiment/features/blogs/domain/repositories/blogs_repository.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource remoteDataSource;

  BlogRepositoryImpl(this.remoteDataSource);

  @override
  Future<PaginatedBlogsModel> getBlogs({
    required int page,
    required int limit,
  }) async {
    return await remoteDataSource.getBlogs(page: page, limit: limit);
  }
}
