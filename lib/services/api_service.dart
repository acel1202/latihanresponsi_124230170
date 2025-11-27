import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://api.spaceflightnewsapi.net/v4";

  static Future<List<dynamic>> fetchList(String menu) async {
    final url = "$baseUrl/$menu/";

    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(resp.body);
        // API returns top-level object with "results"
        if (jsonData.containsKey('results')) {
          return jsonData['results'] as List<dynamic>;
        }

        return jsonDecode(resp.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load $menu (status ${resp.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching $menu: $e');
    }
  }

  static Future<Map<String, dynamic>> fetchDetail(
      String menu, dynamic id) async {
    final url = "$baseUrl/$menu/$id/";

    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(resp.body);
        return jsonData;
      } else {
        throw Exception(
            'Failed to load detail $menu/$id (status ${resp.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching detail $menu/$id: $e');
    }
  }
}
