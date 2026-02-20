import 'package:flutter_experiment/features/blogs/data/models/blog_model.dart';

abstract interface class BlogRepository {
  Future<PaginatedBlogsModel> getBlogs({required int page, required int limit});

  Future<BlogModel> createBlog({
    required String title,
    required String content,
    String? imagePath,
  });

  Future<BlogDeleteMessageModel> deleteBlog({required String id});
}
