class ArticleModel {
  final int id;
  final String title;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final String publishedAt;
  final String updatedAt;

  ArticleModel({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
    required this.updatedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      newsSite: json['news_site'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      publishedAt: json['published_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'image_url': imageUrl,
      'news_site': newsSite,
      'summary': summary,
      'published_at': publishedAt,
      'updated_at': updatedAt,
    };
  }
}
