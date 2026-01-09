import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_routes.dart';
import '../repositery/customer_repo.dart';

final customerControllerProvider =
    StateNotifierProvider<CustomerController, bool>(
      (ref) => CustomerController(ref),
    );

class CustomerController extends StateNotifier<bool> {
  final Ref ref;
  final CustomerRepository _repo = CustomerRepository();

  CustomerController(this.ref) : super(false);

  // 🔹 Snackbar helper
  void _showSnack(BuildContext context, String title, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title: $message'),
          backgroundColor: title == 'Success' ? Colors.green : Colors.redAccent,
        ),
      );
    }
  }

  // ✅ FIXED ADD CUSTOMER FUNCTION
  Future<void> addCustomer(
    BuildContext context, {
    required String name,
    required String phone,
    required String email,
    required String serviceType,
  }) async {
    state = true;
    print('🔹 addCustomer called');
    print(
      '➡️ Sending data: name=$name, phone=$phone, email=$email, serviceType=$serviceType',
    );

    try {
      final res = await _repo.addCustomer(
        name: name,
        phone: phone,
        email: email,
        serviceType: serviceType,
      );

      state = false;

      print('🔸 API Response: $res');

      // 🧠 FIX: Handle API that sends wrong boolean
      bool success = false;

      if (res['status'] == true) {
        success = true;
      } else if (res['message']?.toString().toLowerCase().contains('success') ==
          true) {
        // ✅ If message says success, we treat it as success
        success = true;
      }

      print('🔹 Interpreted Success: $success');
      print('🔹 Message: ${res['message']}');

      if (success) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.dashboard,
          (route) => false,
        );
      }

      _showSnack(
        context,
        success ? 'Success' : 'Error',
        res['message'] ?? 'No message',
      );
    } catch (e) {
      state = false;
      print('❌ Error in addCustomer: $e');
      _showSnack(context, 'Error', 'Something went wrong');
    }
  }

  // ✅ GET ALL CUSTOMERS
  Future<List<dynamic>> getAllCustomers(BuildContext context) async {
    state = true;
    final res = await _repo.getAllCustomers();
    state = false;

    if (res['status'] == true && res['data'] != null) {
      return res['data']['customers'] ?? [];
    } else {
      _showSnack(context, 'Error', res['message']);
      return [];
    }
  }

  // ✅ GET CUSTOMER DETAILS
  Future<Map<String, dynamic>?> getCustomerDetails(
  BuildContext context,
  String customerId,
) async {
  state = true;
  final res = await _repo.getCustomerDetails(customerId);
  state = false;

  if (res['status'] == true && res['data'] != null) {
    final data = res['data'];
    // ✅ Merge customer + club bags together
    return {
      ...?data['customer'],
      'customer_club_bags': data['customer_club_bags'] ?? [],
    };
  } else {
    _showSnack(context, 'Error', res['message']);
    return null;
  }
}

  Future<void> updateCustomer(
    BuildContext context, {
    required String id,
    required String name,
    required String phone,
    required String email,
  }) async {
    state = true;
    final res = await _repo.updateCustomer(
      id: id,
      name: name,
      phone: phone,
      email: email,
    );
    state = false;

    if (res['status']) {
      _showSnack(context, 'Success', res['message']);
      Navigator.pop(context, true); // go back to details screen
    } else {
      _showSnack(context, 'Error', res['message']);
    }
  }

  Future<void> deleteCustomer(BuildContext context, String customerId) async {
    state = true;
    try {
      final res = await _repo.deleteCustomer(customerId);
      state = false;

      if (res['status'] == true) {
        _showSnack(context, 'Success', res['message'] ?? 'Customer deleted');
        Navigator.pop(context, true); // Go back after delete
      } else {
        _showSnack(context, 'Error', res['message'] ?? 'Delete failed');
      }
    } catch (e) {
      state = false;
      _showSnack(context, 'Error', 'Something went wrong');
      print('❌ Delete error: $e');
    }
  }

  // ✅ NEW: GET CLUB BAGS (for Storage screen)
  Future<List<dynamic>> getClubBags(BuildContext context) async {
    state = true;
    final res = await _repo.getClubBags();
    state = false;

    if (res['status'] == true && res['data'] != null) {
      // Some APIs return directly list or nested data
      if (res['data'] is List) {
        return res['data'];
      } else if (res['data']['club_bags'] != null) {
        return res['data']['club_bags'];
      } else {
        return [];
      }
    } else {
      _showSnack(context, 'Error', res['message']);
      return [];
    }
  }

  // ✅ CALL CHECK-IN
  Future<void> checkInCustomer(
    BuildContext context, {
    required int customerId,
    required String package,
    required String position,
    required List<Map<String, dynamic>> clubBags,
  }) async {
    state = true;
    final res = await _repo.checkIn(
      customerId: customerId,
      package: package,
      position: position,
      clubBags: clubBags,
    );
    state = false;

    if (res['status'] == false) {
      _showSnack(context, 'Success', 'Customer checked in successfully');

      // ✅ Update local storage status to "Playing"
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('customer_status_$customerId', 'Playing');

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.playing,
        (_) => false,
      );
    } else {
      _showSnack(context, 'Error', res['message']);
    }
  }
}
