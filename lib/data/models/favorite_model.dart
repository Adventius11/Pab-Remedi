class FavoriteModel {
  final String favoriteId;
  final int articleId;
  final String title;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final String url;
  final String publishedAt;
  final String userId;
  final String createdAt;

  FavoriteModel({
    required this.favoriteId,
    required this.articleId,
    required this.title,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.url,
    required this.publishedAt,
    required this.userId,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      favoriteId: map['favoriteId'] as String? ?? '',
      articleId: map['articleId'] as int? ?? 0,
      title: map['title'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      newsSite: map['newsSite'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      url: map['url'] as String? ?? '',
      publishedAt: map['publishedAt'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'favoriteId': favoriteId,
      'articleId': articleId,
      'title': title,
      'imageUrl': imageUrl,
      'newsSite': newsSite,
      'summary': summary,
      'url': url,
      'publishedAt': publishedAt,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}
