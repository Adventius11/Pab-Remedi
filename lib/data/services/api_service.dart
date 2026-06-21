import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class ApiService {
  static const String _baseUrl = 'https://api.spaceflightnewsapi.net/v4/articles/';

  Future<List<ArticleModel>> fetchArticles({int limit = 20}) async {
    final uri = Uri.parse('$_baseUrl?limit=$limit');
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final results = body['results'] as List<dynamic>? ?? [];
      return results.map((e) => ArticleModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load articles: ${response.statusCode}');
    }
  }
}
