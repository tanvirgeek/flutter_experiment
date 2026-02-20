import 'package:flutter_experiment/features/blogs/data/models/blog_model.dart';

abstract class BlogState {}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogLoaded extends BlogState {
  final List<BlogModel> blogs;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;

  BlogLoaded({
    required this.blogs,
    required this.currentPage,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  BlogLoaded copyWith({
    List<BlogModel>? blogs,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return BlogLoaded(
      blogs: blogs ?? this.blogs,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class BlogError extends BlogState {
  final String message;

  BlogError(this.message);
}

class BlogCreating extends BlogState {}

class BlogCreateSuccess extends BlogState {
  final BlogModel blog;

  BlogCreateSuccess(this.blog);
}

class BlogCreateFailure extends BlogState {
  final String message;

  BlogCreateFailure(this.message);
}

class BlogDeleting extends BlogState {}

class BlogDeleteSuccess extends BlogState {
  final String message;
  BlogDeleteSuccess({required this.message});
}

class BlogDeleteFailure extends BlogState {
  final String message;
  BlogDeleteFailure({required this.message});
}
