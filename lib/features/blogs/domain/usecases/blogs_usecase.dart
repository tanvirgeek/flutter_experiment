import 'package:flutter_experiment/features/blogs/data/models/blog_model.dart';
import 'package:flutter_experiment/features/blogs/domain/repositories/blogs_repository.dart';

abstract interface class GetBlogsUseCase {
  Future<PaginatedBlogsModel> call({required int page, required int limit});
}

class GetBlogsUseCaseImpl implements GetBlogsUseCase {
  final BlogRepository repository;

  GetBlogsUseCaseImpl(this.repository);

  @override
  Future<PaginatedBlogsModel> call({
    required int page,
    required int limit,
  }) async {
    return await repository.getBlogs(page: page, limit: limit);
  }
}
