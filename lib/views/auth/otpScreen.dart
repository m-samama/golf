// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controllers/auth_controller.dart';

// class OTPScreen extends StatefulWidget {
//   final String email;
//   final bool isReset; // if true → reset password flow, otherwise registration

//   const OTPScreen({super.key, required this.email, this.isReset = false});

//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final authController = Get.find<AuthController>();
//   final otpController = TextEditingController();
//   late Timer countdownTimer;
//   int seconds = 120;
//   bool canResend = false;

//   @override
//   void initState() {
//     super.initState();
//     startCountdown();
//   }

//   void startCountdown() {
//     countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (!mounted) return;
//       if (seconds > 0) {
//         setState(() => seconds--);
//       } else {
//         setState(() => canResend = true);
//         timer.cancel();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     countdownTimer.cancel();
//     otpController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F8F8),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // 🔹 App Logo or Animation
//               const Icon(
//                 Icons.lock_outline,
//                 size: 100,
//                 color: Color(0xFF8E2DE2),
//               ),
//               const SizedBox(height: 20),

//               Text(
//                 widget.isReset ? "Reset Password OTP" : "Verify Your Email",
//                 style: const TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF4A00E0),
//                 ),
//               ),
//               const SizedBox(height: 10),

//               Text(
//                 "We’ve sent an OTP to ${widget.email}",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.grey, fontSize: 15),
//               ),
//               const SizedBox(height: 40),

//               // 🔹 OTP Input
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: otpController,
//                   maxLength: 6,
//                   keyboardType: TextInputType.number,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     letterSpacing: 8,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF4A00E0),
//                   ),
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     counterText: "",
//                     hintText: "Enter 6-digit OTP",
//                     hintStyle: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 40),

// // 🔹 Verify Button
// Obx(() {
//   return ElevatedButton(
//     onPressed: authController.isLoading.value
//         ? null
//         : () async {
//             final otp = otpController.text.trim();
//             if (otp.isEmpty || otp.length < 6) {
//               Get.snackbar('Error', 'Please enter valid OTP');
//               return;
//             }

//             if (widget.isReset) {
//               // For password reset, move to reset password flow
//               Get.toNamed('/reset-password', arguments: {
//                 "email": widget.email,
//                 "otp": otp,
//               });
//             } else {
//               // Normal registration verification
//               await authController.verifyOtp(
//                 widget.email,
//                 otp,
//               );
//             }
//           },
//     style: ElevatedButton.styleFrom(
//       minimumSize: const Size(double.infinity, 55),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(14),
//       ),
//       backgroundColor: const Color(0xFF2F8B3B),
//       foregroundColor: Colors.white,
//     ),
//     child: authController.isLoading.value
//         ? const CircularProgressIndicator(color: Colors.white)
//         : const Text(
//             "Verify OTP",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//   );
// }),

//               const SizedBox(height: 25),

//               // 🔹 Resend OTP
//               TextButton.icon(
//                 onPressed: canResend
//                     ? () async {
//                         setState(() {
//                           canResend = false;
//                           seconds = 120;
//                         });
//                         await authController.resendOtp(widget.email);
//                         startCountdown();
//                       }
//                     : null,
//                 icon: const Icon(Icons.refresh),
//                 label: Text(
//                   canResend
//                       ? "Resend OTP"
//                       : "Resend in ${seconds.toString()}s",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: canResend
//                         ? const Color(0xFF4A00E0)
//                         : Colors.grey.shade600,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // 🔹 Cancel Button
//               OutlinedButton.icon(
//                 onPressed: () => Get.offAllNamed('/login'),
//                 icon: const Icon(Icons.arrow_back, color: Colors.red),
//                 label: const Text(
//                   "Back to Login",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 style: OutlinedButton.styleFrom(
//                   side: const BorderSide(color: Colors.red, width: 1.5),
//                   foregroundColor: Colors.red,
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf/views/auth/login.dart';
import '../../../controllers/auth_controller.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String email;
  final bool isReset;

  const OTPScreen({super.key, required this.email, this.isReset = false});

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final otpController = TextEditingController();
  late Timer countdownTimer;
  int seconds = 120;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        setState(() => canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authLoading = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);

    final defaultPinTheme = PinTheme(
      width: 55,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Back Button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Title
                const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please Sign up to continue.",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 40),

                // 🔹 OTP Instruction
                const Text(
                  "Enter your OTP code here.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // 🔹 OTP Input using Pinput
                Center(
                  child: Pinput(
                    length: 6,
                    controller: otpController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),

                const SizedBox(height: 40),

                // 🔹 Verify OTP Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authLoading
                        ? null
                        : () async {
                            final otp = otpController.text.trim();
                            if (otp.length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter 6-digit OTP'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }

                            // ✅ Call verifyOtp and let it handle navigation
                            await authController.verifyOtp(
                              widget.email,
                              otp,
                              widget.isReset,
                              context,
                            );
                          },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Verify OTP",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Resend OTP
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "I did not receive the code",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton.icon(
                        onPressed: canResend
                            ? () async {
                                setState(() {
                                  canResend = false;
                                  seconds = 120;
                                });
                                await authController.resendOtp(
                                  widget.email,
                                  context,
                                );
                                startCountdown();
                              }
                            : null,
                        icon: const Icon(Icons.refresh, color: Colors.green),
                        label: Text(
                          canResend ? "Resend CODE" : "Resend in ${seconds}s",
                          style: TextStyle(
                            color: canResend ? Colors.green : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
