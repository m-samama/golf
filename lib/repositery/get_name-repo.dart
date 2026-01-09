import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final String baseUrl = "https://golf.zillowdigital.com/api/v1";

  Future<String?> getProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('No token found. Please login again.');
    }

    final url = Uri.parse('$baseUrl/profile/get');
    print('📡 Fetching profile from: $url');
    print('🔑 Using token: $token');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    print('🧾 Response Code: ${response.statusCode}');
    print('🧾 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Flexible parsing (depending on API structure)
      final name = data['data']?['user']?['name'] ??
          data['data']?['name'] ??
          data['name'] ??
          'Guest';

      print('✅ Extracted name: $name');
      return name;
    } else {
      print('❌ Failed to load profile: ${response.statusCode}');
      print('❌ Body: ${response.body}');
      return 'Guest';
    }
  }
}
