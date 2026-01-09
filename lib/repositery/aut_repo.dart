import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String baseUrl = "https://golf.zillowdigital.com/api/v1/auth";

  // 🔹 Handle API response safely
  Map<String, dynamic> _handleResponse(http.Response res) {
    try {
      final data = jsonDecode(res.body);
      return {
        'status': res.statusCode == 200,
        'message': data['message'] ?? 'Unknown error',
        'data': data['data'] ?? {},
      };
    } catch (e) {
      return {'status': false, 'message': 'Invalid response format'};
    }
  }

  // 🔹 REGISTER
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
      }),
    );
    return _handleResponse(res);
  }

  // 🔹 VERIFY OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp, required bool isReset,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );
    return _handleResponse(res);
  }

  // 🔹 RESEND OTP
  Future<Map<String, dynamic>> resendOtp({required String email}) async {
    final res = await http.post(
      Uri.parse('$baseUrl/resend-otp'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );
    return _handleResponse(res);
  }

  // ✅ LOGIN
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = _handleResponse(res);

    if (data['status'] && data['data']['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['data']['token']);
      await prefs.setString('session_id', data['data']['session_id'].toString());
      await prefs.setString('user_name', data['data']['user']['name'] ?? '');
      await prefs.setString('user_email', data['data']['user']['email'] ?? '');
    }

    return data;
  }

  // 🔹 FORGOT PASSWORD
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    final res = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );
    return _handleResponse(res);
  }

  // 🔹 RESET PASSWORD
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "otp": otp,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      }),
    );
    return _handleResponse(res);
  }

  //  // 🔹 LOGOUT
  // Future<Map<String, dynamic>> logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');

  //   if (token == null) {
  //     return {'status': false, 'message': 'No user logged in'};
  //   }

  //   final res = await http.post(
  //     Uri.parse('$baseUrl/logout'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //   );

  //   final data = _handleResponse(res);

  //   // ✅ If successful, clear session
  //   if (data['status']) {
  //     await prefs.clear();
  //   }

  //   return data;
  // }

  // 🔹 LOGOUT
Future<Map<String, dynamic>> logout() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    return {'status': false, 'message': 'No user logged in'};
  }

  final res = await http.post(
    Uri.parse('$baseUrl/logout'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  final data = _handleResponse(res);

  if (res.statusCode == 401) {
    // Token expired but still consider it a successful logout
    await prefs.clear();
    return {'status': true, 'message': 'Session expired. Logged out.'};
  }

  if (data['status']) {
    await prefs.clear();
  }

  return data;
}

}
