import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerRepository {
  final String baseUrl = "https://golf.zillowdigital.com/api/v1/customers";
  final String clubBagUrl = "https://golf.zillowdigital.com/api/v1/checkin";

  // 🔹 Safe Response Parser
Map<String, dynamic> _handleResponse(http.Response res) {
  try {
    final data = jsonDecode(res.body);
    final status = data['status'];
    return {
      'status': status == 200 || status == true,
      'message': data['message'] ?? 'Unknown error',
      'data': data['data'] ?? {},
    };
  } catch (e) {
    return {'status': false, 'message': 'Invalid response format'};
  }
}


  // 🔹 ADD CUSTOMER
  Future<Map<String, dynamic>> addCustomer({
    required String name,
    required String phone,
    required String email,
    required String serviceType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.post(
      Uri.parse('$baseUrl/add-customer'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "customer_name": name,
        "phone": phone,
        "email": email,
        "service_type": serviceType,
      }),
    );

    return _handleResponse(res);
  }

  // 🔹 GET ALL CUSTOMERS
  Future<Map<String, dynamic>> getAllCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse('$baseUrl/get-customers'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    return _handleResponse(res);
  }

  // 🔹 GET SINGLE CUSTOMER DETAILS
  Future<Map<String, dynamic>> getCustomerDetails(String customerId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse('$baseUrl/customer-details?customer_id=$customerId'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    return _handleResponse(res);
  }

  // 🔹 UPDATE CUSTOMER
Future<Map<String, dynamic>> updateCustomer({
    required String id,
    required String name,
    required String phone,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.post(
      Uri.parse('$baseUrl/update'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "customer_id": id,
        "customer_name": name,
        "phone": phone,
        "email": email,
      }),
    );

    return _handleResponse(res);
  }

  // 🔹 DELETE CUSTOMER
Future<Map<String, dynamic>> deleteCustomer(String customerId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final res = await http.post(
    Uri.parse('$baseUrl/delete'),
    headers: {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    },
    body: jsonEncode({
      "customer_id": customerId,
    }),
  );

  return _handleResponse(res);
}

 // 🔹 NEW: GET CLUB BAGS LIST (for Storage / Check-in)
  Future<Map<String, dynamic>> getClubBags() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse('$clubBagUrl/club-bags'),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    return _handleResponse(res);
  }

  // ✅ CHECK-IN API CALL
Future<Map<String, dynamic>> checkIn({
  required int customerId,
  required String package,
  required String position,
  required List<Map<String, dynamic>> clubBags,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final res = await http.post(
    Uri.parse('https://golf.zillowdigital.com/api/v1/checkin/checkin'),
    headers: {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    },
    body: jsonEncode({
      "customer_id": customerId,
      "package": package,
      "position": position,
      "club_bags": clubBags,
    }),
  );

  try {
    final data = jsonDecode(res.body);
    return {
      'status': data['status'] == 200 || data['success'] == true,
      'message': data['message'] ?? 'Check-in failed',
      'data': data,
    };
  } catch (e) {
    return {'status': false, 'message': 'Invalid response'};
  }
}


}
