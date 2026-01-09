// search_repo.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchRepo {
  final String baseUrl;
  SearchRepo({required this.baseUrl});

  Future<Map<String, dynamic>> searchCustomers({
    String? search,
    String? status,
    String? serviceType,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int limit = 20,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final queryParams = <String, String>{};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    if (serviceType != null && serviceType.isNotEmpty) {
      queryParams['service_type'] = serviceType;
    }
    if (dateFrom != null && dateFrom.isNotEmpty) queryParams['date_from'] = dateFrom;
    if (dateTo != null && dateTo.isNotEmpty) queryParams['date_to'] = dateTo;
    queryParams['page'] = page.toString();
    queryParams['limit'] = limit.toString();

    final uri = Uri.parse('$baseUrl/api/v1/customers/search-customers')
        .replace(queryParameters: queryParams);

    final res = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Search failed: ${res.body}");
    }
  }
}
