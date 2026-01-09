// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:golf/views/auth/forgotPasswoard.dart';
// import 'package:golf/views/auth/register.dart';
// import '../../controllers/auth_controller.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool _obscure = true;

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final AuthController authController = Get.put(AuthController());

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeColor = const Color(0xFF2F8B3B);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔹 Top bar
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     padding: EdgeInsets.zero,
//                     onPressed: () => Get.back(),
//                     icon: const Icon(Icons.arrow_back_ios_new_rounded,
//                         color: Colors.black),
//                   ),
//                   const CircleAvatar(
//                     radius: 18,
//                     backgroundImage:
//                         AssetImage('assets/images/auth_img.png'),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 12),

//               // 🔹 Illustration
//               Center(
//                 child: Image.asset(
//                   'assets/images/auth_img.png',
//                   height: 240,
//                   fit: BoxFit.contain,
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // 🔹 Title
//               const Text(
//                 'Welcome Back 👋',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.w800,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 'Login to continue your journey.',
//                 style: TextStyle(fontSize: 15, color: Colors.grey[600]),
//               ),

//               const SizedBox(height: 25),

//               // 🔹 Email Field
//               _buildInputField(
//                 hint: 'Email Address',
//                 icon: Icons.email_outlined,
//                 controller: emailController,
//               ),
//               const SizedBox(height: 15),

//               // 🔹 Password Field
//               _buildInputField(
//                 hint: 'Password',
//                 icon: Icons.lock_outline_rounded,
//                 controller: passwordController,
//                 obscureText: _obscure,
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _obscure ? Icons.visibility_off : Icons.visibility,
//                     color: Colors.grey[600],
//                   ),
//                   onPressed: () => setState(() => _obscure = !_obscure),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // 🔹 Forgot Password
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () => Get.to(() => const ForgotPasswordScreen()),
//                   child: Text(
//                     'Forgot Password?',
//                     style: TextStyle(
//                       color: themeColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // 🔹 Login Button (Reactive Loading)
//               Obx(
//                 () => ElevatedButton(
//                   onPressed: authController.isLoading.value
//                       ? null
//                       : () {
//                           final email = emailController.text.trim();
//                           final password = passwordController.text.trim();
//                           if (email.isEmpty || password.isEmpty) {
//                             Get.snackbar(
//                               'Error',
//                               'Please enter both email and password',
//                               snackPosition: SnackPosition.BOTTOM,
//                               backgroundColor: Colors.red.withOpacity(0.1),
//                               colorText: Colors.red,
//                             );
//                             return;
//                           }
//                           authController.login(email, password);
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: themeColor,
//                     foregroundColor: Colors.white,
//                     minimumSize: const Size(double.infinity, 52),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                   ),
//                   child: authController.isLoading.value
//                       ? const SizedBox(
//                           width: 26,
//                           height: 26,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2.4,
//                           ),
//                         )
//                       : const Text(
//                           'Login',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                 ),
//               ),

//               const SizedBox(height: 18),

//               // 🔹 Divider or OR
//               Row(
//                 children: [
//                   Expanded(
//                     child: Divider(color: Colors.grey[300], thickness: 1),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Text("or"),
//                   ),
//                   Expanded(
//                     child: Divider(color: Colors.grey[300], thickness: 1),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 18),

//               // 🔹 Sign Up
//               Center(
//                 child: GestureDetector(
//                   onTap: () => Get.to(() => const SignUpScreen()),
//                   child: RichText(
//                     text: TextSpan(
//                       text: "Don’t have an account? ",
//                       style: TextStyle(color: Colors.grey[700]),
//                       children: [
//                         TextSpan(
//                           text: "Sign Up",
//                           style: TextStyle(
//                             color: themeColor,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 25),

//               // 🔹 Footer
//               Center(
//                 child: Text(
//                   "© 2025 GolfApp by F2Tech",
//                   style: TextStyle(color: Colors.grey[500], fontSize: 12),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ✅ Common Input Field
//   Widget _buildInputField({
//     required String hint,
//     required IconData icon,
//     required TextEditingController controller,
//     bool obscureText = false,
//     Widget? suffixIcon,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7F7F8),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           hintText: hint,
//           prefixIcon: Icon(icon, color: Colors.grey[700]),
//           suffixIcon: suffixIcon,
//           border: InputBorder.none,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf/views/auth/forgotPasswoard.dart';
import 'package:golf/views/auth/register.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscure = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both email and password"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final authController = ref.read(authControllerProvider.notifier);
    await authController.login(email, password, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    final themeColor = const Color(0xFF2F8B3B);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ),
                      ),
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            AssetImage('assets/images/auth_img.png'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 🔹 Illustration
                  Center(
                    child: Image.asset(
                      'assets/images/auth_img.png',
                      height: 240,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Welcome Back 👋',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Login to continue your journey.',
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 25),

                  _buildInputField(
                    hint: 'Email Address',
                    icon: Icons.email_outlined,
                    controller: emailController,
                  ),
                  const SizedBox(height: 15),

                  _buildInputField(
                    hint: 'Password',
                    icon: Icons.lock_outline_rounded,
                    controller: passwordController,
                    obscureText: _obscure,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.grey[300], thickness: 1),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("or"),
                      ),
                      Expanded(
                        child: Divider(color: Colors.grey[300], thickness: 1),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUpScreen(),
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: "Don’t have an account? ",
                          style: TextStyle(color: Colors.grey[700]),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: themeColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Center(
                    child: Text(
                      "© 2025 GolfApp by F2Tech",
                      style:
                          TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Overlay loader
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2F8B3B)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey[700]),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}
