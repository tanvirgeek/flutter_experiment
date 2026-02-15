import 'package:flutter_experiment/core/network/api_client.dart';
import 'package:flutter_experiment/features/blogs/data/models/blog_model.dart';

abstract interface class BlogRemoteDataSource {
  Future<PaginatedBlogsModel> getBlogs({required int page, required int limit});
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final ApiClient apiClient;

  BlogRemoteDataSourceImpl(this.apiClient);

  @override
  Future<PaginatedBlogsModel> getBlogs({
    required int page,
    required int limit,
  }) async {
    final response = await apiClient.get(
      "/blogs",
      queryParameters: {"page": page, "limit": limit},
    );

    return PaginatedBlogsModel.fromJson(response.data);
  }
}
