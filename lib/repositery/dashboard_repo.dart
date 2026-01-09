import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardRepository {
  final String baseUrl;

  DashboardRepository({required this.baseUrl});

  Future<Map<String, dynamic>> getDashboardCounts() async {
    final url = Uri.parse('$baseUrl/api/v1/dashboard/index');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 200 && body['data'] != null) {
          return body['data']['counts'] ?? {};
        }
      }
      return {};
    } catch (e) {
      print('❌ DashboardRepo error: $e');
      return {};
    }
  }
}
