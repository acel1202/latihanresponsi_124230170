import '../services/api_service.dart';

class BlogController {
  Future<List<dynamic>> getBlogs() => ApiService.fetchList("blogs");
  Future<Map<String, dynamic>> getDetail(dynamic id) =>
      ApiService.fetchDetail("blogs", id);
}
