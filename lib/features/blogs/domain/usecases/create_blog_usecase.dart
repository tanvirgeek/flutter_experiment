import 'package:flutter_experiment/features/blogs/data/models/blog_model.dart';
import 'package:flutter_experiment/features/blogs/domain/repositories/blogs_repository.dart';

abstract interface class CreateBlogUseCase {
  Future<BlogModel> call({
    required String title,
    required String content,
    String? imagePath,
  });
}

class CreateBlogUseCaseImpl implements CreateBlogUseCase {
  final BlogRepository repository;

  CreateBlogUseCaseImpl(this.repository);

  @override
  Future<BlogModel> call({
    required String title,
    required String content,
    String? imagePath,
  }) {
    return repository.createBlog(
      title: title,
      content: content,
      imagePath: imagePath,
    );
  }
}
