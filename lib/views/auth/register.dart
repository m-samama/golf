// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controllers/auth_controller.dart';
// import 'login.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _name = TextEditingController();
//   final _email = TextEditingController();
//   final _phone = TextEditingController();
//   final _password = TextEditingController();

//   final auth = Get.find<AuthController>();
//   bool _obscure = true;

//   @override
//   void dispose() {
//     _name.dispose();
//     _email.dispose();
//     _phone.dispose();
//     _password.dispose();
//     super.dispose();
//   }

// void _registerUser() {
//   if (_formKey.currentState!.validate()) {
//     auth.register(
//       _name.text.trim(),
//       _email.text.trim(),
//       _phone.text.trim(),
//       _password.text.trim(),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 🔹 Illustration
//                 Center(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     width: MediaQuery.of(context).size.width * 0.85,
//                     height: 260,
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage('assets/images/auth_img.png'),
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 8),
//                 const Text(
//                   'Sign up',
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 6),
//                 const Text(
//                   'Please sign up to continue.',
//                   style: TextStyle(color: Colors.grey, fontSize: 14),
//                 ),
//                 const SizedBox(height: 24),

//                 // 🔹 Full Name
//                 _buildField(
//                   _name,
//                   'Full name',
//                   Icons.person,
//                   (v) => (v == null || v.isEmpty) ? 'Enter your name' : null,
//                 ),
//                 const SizedBox(height: 14),

//                 // 🔹 Email
//                 _buildField(
//                   _email,
//                   'Email',
//                   Icons.email,
//                   (v) => GetUtils.isEmail(v ?? '') ? null : 'Enter valid email',
//                 ),
//                 const SizedBox(height: 14),

//                 // 🔹 Phone
//                 _buildField(
//                   _phone,
//                   'Phone number',
//                   Icons.phone,
//                   (v) => (v == null || v.length < 10)
//                       ? 'Enter valid phone number'
//                       : null,
//                   keyboard: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 14),

//                 // 🔹 Password (toggle visibility)
//                 _buildField(
//                   _password,
//                   'Password',
//                   Icons.lock,
//                   (v) => (v == null || v.length < 6)
//                       ? 'Minimum 6 characters'
//                       : null,
//                   obscure: _obscure,
//                   onToggleEye: () => setState(() {
//                     _obscure = !_obscure;
//                   }),
//                 ),

//                 const SizedBox(height: 26),

//                 // 🔹 Sign Up button
//                 Obx(
//                   () => ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF2F8B3B),
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: auth.isLoading.value ? null : _registerUser,
//                     child: auth.isLoading.value
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                             "Sign Up",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // 🔹 Already have account
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Joined us before? ',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     GestureDetector(
//                       onTap: () => Get.to(() => const LoginScreen()),
//                       child: const Text(
//                         'Login',
//                         style: TextStyle(
//                           color: Color(0xFF2F7A2E),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// 🔹 Custom Reusable Input Field
//   Widget _buildField(
//     TextEditingController controller,
//     String hint,
//     IconData icon,
//     String? Function(String?) validator, {
//     bool obscure = false,
//     VoidCallback? onToggleEye,
//     TextInputType keyboard = TextInputType.text,
//   }) {
//     return TextFormField(
//       controller: controller,
//       validator: validator,
//       obscureText: obscure,
//       keyboardType: keyboard,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: const Color(0xFFF0F0F0),
//         hintText: hint,
//         prefixIcon: Icon(icon, color: Colors.grey),
//         suffixIcon: onToggleEye != null
//             ? IconButton(
//                 icon: Icon(
//                   obscure ? Icons.visibility_off : Icons.visibility,
//                   color: Colors.grey,
//                 ),
//                 onPressed: onToggleEye,
//               )
//             : null,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 18,
//           horizontal: 18,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/auth_controller.dart';
import 'login.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

 Future<void> _registerUser() async {
  if (!_formKey.currentState!.validate()) return;

  final auth = ref.read(authControllerProvider.notifier);
  final emailValue = _email.text.trim();

  await auth.register(
    _name.text.trim(),
    emailValue,
    _phone.text.trim(),
    _password.text.trim(),
    context,
  );

  // ✅ Clear fields after successful submission
  _name.clear();
  _email.clear();
  _phone.clear();
  _password.clear();
}



  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: 
      ref.watch(authControllerProvider)
                    ? Center(child: const CircularProgressIndicator(color: Color(0xFF2F8B3B),))
                    : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Illustration
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 260,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/auth_img.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                const Text(
                  'Sign up',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Please sign up to continue.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),

                // 🔹 Name
                _buildField(
                  controller: _name,
                  hint: 'Full name',
                  icon: Icons.person,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter your name' : null,
                ),
                const SizedBox(height: 14),

                // 🔹 Email
                _buildField(
                  controller: _email,
                  hint: 'Email',
                  icon: Icons.email,
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Enter valid email'
                      : null,
                ),
                const SizedBox(height: 14),

                // 🔹 Phone
                _buildField(
                  controller: _phone,
                  hint: 'Phone number',
                  icon: Icons.phone,
                  validator: (v) => (v == null || v.length < 10)
                      ? 'Enter valid phone number'
                      : null,
                  keyboard: TextInputType.phone,
                ),
                const SizedBox(height: 14),

                // 🔹 Password
                _buildField(
                  controller: _password,
                  hint: 'Password',
                  icon: Icons.lock,
                  validator: (v) => (v == null || v.length < 6)
                      ? 'Minimum 6 characters'
                      : null,
                  obscure: _obscure,
                  onToggleEye: () => setState(() {
                    _obscure = !_obscure;
                  }),
                ),
                const SizedBox(height: 26),

                ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F8B3B),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isLoading ? null : _registerUser,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),

                const SizedBox(height: 20),

                // 🔹 Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Joined us before? ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFF2F7A2E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Reusable TextField
  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscure = false,
    VoidCallback? onToggleEye,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscure,
      keyboardType: keyboard,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: onToggleEye != null
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: onToggleEye,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 18,
        ),
      ),
    );
  }
}
