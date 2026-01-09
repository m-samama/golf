// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import '../repositery/profile_repo.dart';

// final profileControllerProvider =
//     StateNotifierProvider<ProfileController, bool>(
//       (ref) => ProfileController(ref),
//     );

// class ProfileController extends StateNotifier<bool> {
//   final Ref ref;
//   final ProfileRepository _repo = ProfileRepository();

//   ProfileController(this.ref) : super(false);

// /// 🔹 Change Password Function
// Future<void> changePassword({
//   required BuildContext context,
//   required String currentPassword,
//   required String newPassword,
//   required String confirmPassword,
// }) async {
//   state = true;
//   final res = await _repo.changePassword(
//     currentPassword: currentPassword,
//     newPassword: newPassword,
//     confirmPassword: confirmPassword,
//   );
//   state = false;

//   if (context.mounted) {
//     print(context);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(res['message']),
//         backgroundColor: res['status'] ? Colors.green : Colors.redAccent,
//       ),
//     );
//   }
// }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../config/app_routes.dart';
import '../repositery/profile_repo.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, bool>(
      (ref) => ProfileController(ref),
    );

class ProfileController extends StateNotifier<bool> {
  final Ref ref;
  final ProfileRepository _repo = ProfileRepository();

  ProfileController(this.ref) : super(false);

  /// 🔹 Get Profile Data
  Future<Map<String, dynamic>> getProfile() async {
    state = true;
    final res = await _repo.getProfile();
    state = false;
    return res;
  }

  /// 🔹 Update Profile Data
  Future<void> updateProfile({
    required BuildContext context,
    required String name,
    required String phone,
  }) async {
    state = true;
    final res = await _repo.updateProfile(name: name, phone: phone);
    state = false;

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message']),
          backgroundColor: res['status'] ? Colors.green : Colors.redAccent,
        ),
      );
    }
  }

  /// 🔹 Change Password Function
  Future<void> changePassword({
    required BuildContext context,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = true;
    final res = await _repo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    state = false;

    if (context.mounted) {
      print(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message']),
          backgroundColor: res['status'] ? Colors.green : Colors.redAccent,
        ),
      );
    }
  }
}
