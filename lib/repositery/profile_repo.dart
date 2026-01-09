// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfileRepository {
//   final String baseUrl = "https://golf.zillowdigital.com/api/v1/profile";

  // /// 🔹 Change Password API
  // Future<Map<String, dynamic>> changePassword({
  //   required String currentPassword,
  //   required String newPassword,
  //   required String confirmPassword,
  // }) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('token');

  //     if (token == null || token.isEmpty) {
  //       return {'status': false, 'message': 'User not logged in'};
  //     }

  //     final url = Uri.parse("$baseUrl/change-password");
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({
  //         'current_password': currentPassword,
  //         'new_password': newPassword,
  //         'confirm_password': confirmPassword,
  //       }),
  //     );

  //     final data = jsonDecode(response.body);
  //     return {
  //       'status': response.statusCode == 200,
  //       'message': data['message'] ?? 'Unknown response',
  //     };
  //   } catch (e) {
  //     print(e);
  //     return {'status': false, 'message': 'Something went wrong: $e'};
  //   }
  // }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final String baseUrl = "https://golf.zillowdigital.com/api/v1/profile";

  
  /// 🔹 Get User Profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        return {'status': false, 'message': 'User not logged in'};
      }

      final url = Uri.parse("$baseUrl/get");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      return {
        'status': response.statusCode == 200,
        'message': data['message'] ?? 'Fetched successfully',
        'data': data['data'] ?? {},
      };
    } catch (e) {
      print('💥 [GetProfile] $e');
      return {'status': false, 'message': 'Something went wrong: $e'};
    }
  }

  /// 🔹 Update User Profile
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String phone,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        return {'status': false, 'message': 'User not logged in'};
      }

      final url = Uri.parse("$baseUrl/update");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'phone': phone,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        'status': response.statusCode == 200,
        'message': data['message'] ?? 'Profile updated successfully',
      };
    } catch (e) {
      print('💥 [UpdateProfile] $e');
      return {'status': false, 'message': 'Something went wrong: $e'};
    }
  }

 /// 🔹 Change Password API
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        return {'status': false, 'message': 'User not logged in'};
      }

      final url = Uri.parse("$baseUrl/change-password");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        'status': response.statusCode == 200,
        'message': data['message'] ?? 'Unknown response',
      };
    } catch (e) {
      print(e);
      return {'status': false, 'message': 'Something went wrong: $e'};
    }
  }
}
