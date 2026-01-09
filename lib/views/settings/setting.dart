// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../config/app_routes.dart';
// import '../../controllers/auth_controller.dart';

// class SettingsView extends StatelessWidget {
//   final AuthController authController = Get.put(AuthController());
//   SettingsView({super.key});

//   Widget _tile(String title, VoidCallback onTap) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Material(
//         color: Colors.grey.shade100, // 👈 white background for tile
//         elevation: 1,
//         borderRadius: BorderRadius.circular(12),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//                 const Icon(Icons.chevron_right, color: Colors.green),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // 👈 white background added
//       appBar: AppBar(
//         title: const Text('Settings'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               _tile('Edit profile', () => Get.toNamed(AppRoutes.editProfile)),
//               _tile(
//                 'Change password',
//                 () => Get.toNamed(AppRoutes.changePassword),
//               ),
//              // _tile('Logout', () => authController.logout()),

//               const Spacer(),

//               const Divider(height: 30, thickness: 0.5),

//               const Text(
//                 '© 2025 YourCompany. All rights reserved',
//                 style: TextStyle(fontSize: 12, color: Colors.black54),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Text(
//                     'Terms & Conditions',
//                     style: TextStyle(color: Colors.green),
//                   ),
//                   SizedBox(width: 8),
//                   Text('and', style: TextStyle(color: Colors.black54)),
//                   SizedBox(width: 8),
//                   Text('Privacy Policy', style: TextStyle(color: Colors.green)),
//                 ],
//               ),
//               const SizedBox(height: 18),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_routes.dart';
import '../../controllers/auth_controller.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  Widget _tile(String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.grey.shade100,
        elevation: 1,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.green),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _tile(
                'Edit Profile',
                () => Navigator.pushNamed(context, AppRoutes.editProfile),
              ),
              _tile(
                'Change Password',
                () => Navigator.pushNamed(context, AppRoutes.changePassword),
              ),
              _tile('Logout', () async {
                await authController.logout(context);
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                }
              }),

              const Spacer(),
              const Divider(height: 30, thickness: 0.5),

              const Text(
                '© 2025 YourCompany. All rights reserved',
                style: TextStyle(fontSize: 12, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Terms & Conditions',
                    style: TextStyle(color: Colors.green),
                  ),
                  SizedBox(width: 8),
                  Text('and', style: TextStyle(color: Colors.black54)),
                  SizedBox(width: 8),
                  Text('Privacy Policy', style: TextStyle(color: Colors.green)),
                ],
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
