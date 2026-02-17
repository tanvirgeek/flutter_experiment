abstract class BlogEvent {}

class FetchBlogsEvent extends BlogEvent {
  final int page;
  final int limit;

  FetchBlogsEvent({required this.page, required this.limit});
}

class LoadMoreBlogsEvent extends BlogEvent {}

class CreateBlogEvent extends BlogEvent {
  final String title;
  final String content;
  final String? imagePath;

  CreateBlogEvent({
    required this.title,
    required this.content,
    this.imagePath,
  });
}

