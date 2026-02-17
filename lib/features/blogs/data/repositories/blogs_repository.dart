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

  @override
  Future<BlogModel> createBlog({
    required String title,
    required String content,
    String? imagePath,
  }) async {
    final model = await remoteDataSource.createBlog(
      CreateBlogRequestModel(
        title: title,
        content: content,
        imagePath: imagePath,
      ),
    );

    return model; // since BlogModel extends Blog
  }
}
