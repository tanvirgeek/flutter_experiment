import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_experiment/features/blogs/domain/usecases/blogs_usecase.dart';
import 'package:flutter_experiment/features/blogs/domain/usecases/create_blog_usecase.dart';
import 'package:flutter_experiment/features/blogs/presentation/bloc/blogs_event.dart';
import 'package:flutter_experiment/features/blogs/presentation/bloc/blogs_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final GetBlogsUseCase getBlogsUseCase;
  final CreateBlogUseCase createBlogUseCase;

  static const int _limit = 10;

  BlogBloc({required this.getBlogsUseCase, required this.createBlogUseCase})
    : super(BlogInitial()) {
    on<FetchBlogsEvent>(_onFetchBlogs);
    on<LoadMoreBlogsEvent>(_onLoadMoreBlogs);
    on<CreateBlogEvent>(_onCreateBlog);
  }

  Future<void> _onFetchBlogs(
    FetchBlogsEvent event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading());

    try {
      final result = await getBlogsUseCase.call(
        page: event.page,
        limit: event.limit,
      );

      emit(
        BlogLoaded(
          blogs: result.blogs,
          currentPage: result.page,
          totalPages: result.pages,
        ),
      );
    } catch (e) {
      emit(BlogError(e.toString()));
    }
  }

  Future<void> _onLoadMoreBlogs(
    LoadMoreBlogsEvent event,
    Emitter<BlogState> emit,
  ) async {
    final currentState = state;

    if (currentState is BlogLoaded) {
      if (currentState.isLoadingMore) return;

      if (currentState.currentPage >= currentState.totalPages) return;

      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final nextPage = currentState.currentPage + 1;

        final result = await getBlogsUseCase.call(
          page: nextPage,
          limit: _limit,
        );

        final updatedBlogs = [...currentState.blogs, ...result.blogs];

        emit(
          BlogLoaded(
            blogs: updatedBlogs,
            currentPage: result.page,
            totalPages: result.pages,
          ),
        );
      } catch (_) {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }

  Future<void> _onCreateBlog(
    CreateBlogEvent event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogCreating());

    try {
      final blog = await createBlogUseCase.call(
        title: event.title,
        content: event.content,
        imagePath: event.imagePath,
      );

      emit(BlogCreateSuccess(blog));
    } catch (e) {
      emit(BlogCreateFailure(e.toString()));
    }
  }
}
