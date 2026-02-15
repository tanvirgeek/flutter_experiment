abstract class BlogEvent {}

class FetchBlogsEvent extends BlogEvent {
  final int page;
  final int limit;

  FetchBlogsEvent({required this.page, required this.limit});
}

class LoadMoreBlogsEvent extends BlogEvent {}
