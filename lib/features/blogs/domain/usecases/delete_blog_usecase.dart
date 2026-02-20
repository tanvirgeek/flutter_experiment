import 'package:flutter_experiment/features/blogs/data/models/blog_model.dart';
import 'package:flutter_experiment/features/blogs/domain/repositories/blogs_repository.dart';

abstract interface class DeleteBlogUseCase {
  Future<BlogDeleteMessageModel> call({required String id});
}

class DeleteBlogUsecaseImpl implements DeleteBlogUseCase {
  final BlogRepository repository;

  DeleteBlogUsecaseImpl({required this.repository});

  @override
  Future<BlogDeleteMessageModel> call({required String id}) {
    return repository.deleteBlog(id: id);
  }
}
