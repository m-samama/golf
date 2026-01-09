// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../controllers/auth_controller.dart';

// class ResetPasswordView extends ConsumerStatefulWidget {
//   const ResetPasswordView({super.key});

//   @override
//   ConsumerState<ResetPasswordView> createState() => _ResetPasswordViewState();
// }

// class _ResetPasswordViewState extends ConsumerState<ResetPasswordView> {
//   final _newCtrl = TextEditingController();
//   final _confirmCtrl = TextEditingController();
//   bool _obscureNew = true;
//   bool _obscureConfirm = true;

//   @override
//   void dispose() {
//     _newCtrl.dispose();
//     _confirmCtrl.dispose();
//     super.dispose();
//   }

//   Widget _passwordField({
//     required String label,
//     required TextEditingController controller,
//     required bool obscure,
//     required VoidCallback toggle,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscure,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.grey.shade100,
//         suffixIcon: IconButton(
//           icon: Icon(
//             obscure ? Icons.visibility_off : Icons.visibility,
//             color: Colors.green,
//           ),
//           onPressed: toggle,
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 18,
//           horizontal: 16,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.green, width: 1.5),
//         ),
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     final isLoading = ref.watch(authControllerProvider);
//     final authController = ref.read(authControllerProvider.notifier);

//     final args = ModalRoute.of(context)!.settings.arguments as Map?;
//     final email = args?['email'] ?? '';
//     final otp = args?['otp'] ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reset Password'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Center(
//           child: Column(
//             children: [
//               const SizedBox(height: 40),
//               _passwordField(
//                   label: 'New password',
//                   controller: _newCtrl,
//                   obscure: _obscureNew,
//                   toggle: () => setState(() => _obscureNew = !_obscureNew),
//                 ),
//               const SizedBox(height: 16),
//               _passwordField(
//                   label: 'Confirm password',
//                   controller: _confirmCtrl,
//                   obscure: _obscureConfirm,
//                   toggle: () =>
//                       setState(() => _obscureConfirm = !_obscureConfirm),
//                 ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: isLoading
//                     ? null
//                     : () async {
//                         final newPass = _newCtrl.text.trim();
//                         final confirm = _confirmCtrl.text.trim();

//                         if (newPass.isEmpty || confirm.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Please fill all fields'),
//                               backgroundColor: Colors.redAccent,
//                             ),
//                           );
//                           return;
//                         }
//                         if (newPass != confirm) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Passwords do not match'),
//                               backgroundColor: Colors.redAccent,
//                             ),
//                           );
//                           return;
//                         }

//                         await authController.resetPassword(
//                           email,
//                           otp,
//                           newPass,
//                           confirm,
//                           context,
//                         );
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   minimumSize: const Size(double.infinity, 55),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text(
//                         'Confirm',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/auth_controller.dart';

class ResetPasswordView extends ConsumerStatefulWidget {
  const ResetPasswordView({super.key});

  @override
  ConsumerState<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends ConsumerState<ResetPasswordView> {
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.green,
          ),
          onPressed: toggle,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);

    // ✅ Extract arguments safely
    final args =
        (ModalRoute.of(context)?.settings.arguments ?? {})
            as Map<String, dynamic>;
    final email = (args['email'] ?? '').toString().trim();
    final otp = (args['otp'] ?? '').toString().trim();

    print("📩 Email passed: $email | OTP passed: $otp"); // Debugging

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_reset_rounded,
                  size: 50,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Create New Password",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your new password must be different from your previous one.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 40),

              _passwordField(
                label: 'New Password',
                controller: _newCtrl,
                obscure: _obscureNew,
                toggle: () => setState(() => _obscureNew = !_obscureNew),
              ),
              const SizedBox(height: 16),
              _passwordField(
                label: 'Confirm Password',
                controller: _confirmCtrl,
                obscure: _obscureConfirm,
                toggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final newPass = _newCtrl.text.trim();
                          final confirmPass = _confirmCtrl.text.trim();

                          if (email.isEmpty || otp.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Email or OTP missing. Please go back and try again.',
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          if (newPass.isEmpty || confirmPass.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          if (newPass != confirmPass) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          print(
                            "✅ Sending reset request → $email | $otp | $newPass",
                          );

                          await authController.resetPassword(
                            email,
                            otp,
                            newPass,
                            confirmPass,
                            context,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Make sure to remember your new password.",
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
