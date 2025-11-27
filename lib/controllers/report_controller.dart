import '../services/api_service.dart';

class ReportController {
  Future<List<dynamic>> getReports() => ApiService.fetchList("reports");
  Future<Map<String, dynamic>> getDetail(dynamic id) =>
      ApiService.fetchDetail("reports", id);
}
