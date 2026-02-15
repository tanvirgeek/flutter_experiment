class BlogModel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String author;
  final DateTime createdAt;
  final DateTime updatedAt;

  BlogModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['_id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      author: json['author'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class PaginatedBlogsModel {
  final int total;
  final int page;
  final int pages;
  final List<BlogModel> blogs;

  PaginatedBlogsModel({
    required this.total,
    required this.page,
    required this.pages,
    required this.blogs,
  });

  factory PaginatedBlogsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedBlogsModel(
      total: json['total'],
      page: json['page'],
      pages: json['pages'],
      blogs: (json['blogs'] as List).map((e) => BlogModel.fromJson(e)).toList(),
    );
  }
}
