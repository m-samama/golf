// lib/views/edit_customer_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/customer_controller.dart';

class EditCustomerView extends ConsumerStatefulWidget {
  final String customerId;
  const EditCustomerView({super.key, required this.customerId});

  @override
  ConsumerState<EditCustomerView> createState() => _EditCustomerViewState();
}

class _EditCustomerViewState extends ConsumerState<EditCustomerView> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCustomer());
  }

 Future<void> _loadCustomer() async {
  final res = await ref
      .read(customerControllerProvider.notifier)
      .getCustomerDetails(context, widget.customerId);

  print('🔹 Loaded customer data: $res');

  if (res != null) {
    // 🔹 If nested under "customer"
    final customer = res['customer'] ?? res;

    setState(() {
      nameController.text = customer['customer_name'] ?? '';
      phoneController.text = customer['phone'] ?? '';
      emailController.text = customer['email'] ?? '';
    });
  }
}



  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(customerControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Customer"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.green),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/bag.jpg'),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Edit Customer Information",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(Icons.person, "Full name", nameController),
                    const SizedBox(height: 16),
                    _buildTextField(Icons.phone, "Phone", phoneController),
                    const SizedBox(height: 16),
                    _buildTextField(Icons.mail, "Email", emailController),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await ref
                              .read(customerControllerProvider.notifier)
                              .updateCustomer(
                                context,
                                id: widget.customerId,
                                name: nameController.text.trim(),
                                phone: phoneController.text.trim(),
                                email: emailController.text.trim(),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Update Customer",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
      IconData icon, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 1.5),
        ),
      ),
    );
  }
}
