import '../services/api_service.dart';

class ArticleController {
  Future<List<dynamic>> getArticles() => ApiService.fetchList("articles");
  Future<Map<String, dynamic>> getDetail(dynamic id) =>
      ApiService.fetchDetail("articles", id);
}
