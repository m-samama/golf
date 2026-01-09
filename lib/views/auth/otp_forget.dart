// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../controllers/auth_controller.dart';

// class OTPForgetScreen extends ConsumerStatefulWidget {
//   final String email;
//   final bool isReset; // true → forgot password flow

//   const OTPForgetScreen({super.key, required this.email, this.isReset = false});

//   @override
//   ConsumerState<OTPForgetScreen> createState() => _OTPForgetScreenState();
// }

// class _OTPForgetScreenState extends ConsumerState<OTPForgetScreen> {
//   final TextEditingController otpForgetController = TextEditingController();
//   late Timer countdownTimer;
//   int seconds = 120;
//   bool canResendForget = false;

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
//         setState(() => canResendForget = true);
//         timer.cancel();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     countdownTimer.cancel();
//     otpForgetController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authLoading = ref.watch(authControllerProvider);
//     final authController = ref.read(authControllerProvider.notifier);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F8F8),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.lock_outline,
//                 size: 100,
//                 color: Color(0xFF8E2DE2),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 widget.isReset ? "Reset Password OTP" : "Verify OTP",
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
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
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
//                   controller: otpForgetController,
//                   maxLength: 6,
//                   keyboardType: TextInputType.number,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     letterSpacing: 6,
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

//               // 🔹 Verify Button
//               ElevatedButton(
//                 onPressed: authLoading
//                     ? null
//                     : () async {
//                         final otp = otpForgetController.text.trim();
//                         if (otp.isEmpty || otp.length < 6) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Please enter a valid 6-digit OTP'),
//                               backgroundColor: Colors.redAccent,
//                             ),
//                           );
//                           return;
//                         }

//                         // ✅ Verify OTP via AuthController
//                         await authController.verifyOtpForget(
//                           widget.email,
//                           otp,
//                           context,
//                         );
//                       },
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 55),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   backgroundColor: const Color(0xFF2F8B3B),
//                   foregroundColor: Colors.white,
//                 ),
//                 child: authLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text(
//                         "Verify OTP",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//               ),
//               const SizedBox(height: 25),

//               // 🔹 Resend OTP
//               TextButton.icon(
//                 onPressed: canResendForget
//                     ? () async {
//                         setState(() {
//                           canResendForget = false;
//                           seconds = 120;
//                         });
//                         await authController.resendOtp(widget.email, context);
//                         startCountdown();
//                       }
//                     : null,
//                 icon: const Icon(Icons.refresh),
//                 label: Text(
//                   canResendForget ? "Resend OTP" : "Resend in ${seconds}s",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: canResendForget
//                         ? const Color(0xFF4A00E0)
//                         : Colors.grey.shade600,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),

//               // 🔹 Back to Login
//               OutlinedButton.icon(
//                 onPressed: () {
//                   Navigator.pushNamedAndRemoveUntil(
//                     context,
//                     '/login',
//                     (route) => false,
//                   );
//                 },
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
import 'package:golf/views/auth/forgotPasswoard.dart';
import '../../../controllers/auth_controller.dart';
import 'package:pinput/pinput.dart';

class OTPForgetScreen extends ConsumerStatefulWidget {
  final String email;
  final bool isReset; // true → forgot password flow

  const OTPForgetScreen({super.key, required this.email, this.isReset = false});

  @override
  ConsumerState<OTPForgetScreen> createState() => _OTPForgetScreenState();
}

class _OTPForgetScreenState extends ConsumerState<OTPForgetScreen> {
  final forotpController = TextEditingController();
  late Timer countdownTimer;
  int seconds = 120;
  bool canResendForget = false;

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
        setState(() => canResendForget = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    forotpController.dispose();
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
                // 🔹 Back Arrow
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter the 6-digit OTP sent to your email.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 40),

                // 🔹 OTP Input using Pinput
                Center(
                  child: Pinput(
                    length: 6,
                    controller: forotpController,
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

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: authLoading
                        ? null
                        : () async {
                            final otp = forotpController.text.trim();
                            if (otp.length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter 6-digit OTP'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }

                            debugPrint(
                              "📧 Email: ${widget.email}, 🔢 OTP: $otp",
                            );

                            await authController.verifyOtpForget(
                              widget.email,
                              otp,
                              context,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F8B3B),
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
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 25),

                Center(
                  child: Column(
                    children: [
                      const Text(
                        "Didn’t receive the code?",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      TextButton.icon(
                        onPressed: canResendForget
                            ? () async {
                                setState(() {
                                  canResendForget = false;
                                  seconds = 120;
                                });
                                await authController.resendOtp(
                                  widget.email,
                                  context,
                                );
                                startCountdown();
                              }
                            : null,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text(
                          canResendForget
                              ? "Resend CODE"
                              : "Resend in ${seconds.toString()}s",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: canResendForget
                                ? Colors.green
                                : Colors.grey.shade600,
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
