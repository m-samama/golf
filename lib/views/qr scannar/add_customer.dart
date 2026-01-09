import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/customer_controller.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  int selectedPack = 1; // ✅ Default 1 month selected

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(customerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Customer"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : GestureDetector(
                onTap: () => _openCustomerForm(context),
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add, size: 80, color: Colors.green),
                      SizedBox(height: 8),
                      Text("Add Customer", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _openCustomerForm(BuildContext context) {
    setState(() => selectedPack = 1);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return _buildCustomerForm(context, setDialogState);
          },
        ),
      ),
    );
  }

  Widget _buildCustomerForm(
      BuildContext context, void Function(void Function()) setDialogState) {
    final isLoading = ref.watch(customerControllerProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Header ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Customer Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ---------- Input Fields ----------
            _buildTextField("Customer Name", nameController),
            const SizedBox(height: 14),
            _buildTextField("Phone", phoneController,
                type: TextInputType.phone),
            const SizedBox(height: 14),
            _buildTextField("Email (optional)", emailController,
                type: TextInputType.emailAddress),
            const SizedBox(height: 24),

            // ---------- Service Pack ----------
            const Text(
              "Service Pack",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Center(
              child: Wrap(
                spacing: 10,
                children: [
                  _buildPackButton(1, "1 Month", selectedPack, (val) {
                    setDialogState(() => selectedPack = val);
                  }),
                  _buildPackButton(2, "2 Month", selectedPack, (val) {
                    setDialogState(() => selectedPack = val);
                  }),
                  _buildPackButton(3, "3 Month", selectedPack, (val) {
                    setDialogState(() => selectedPack = val);
                  }),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // ---------- Submit Button ----------
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _submit(context),
                      child: const Text(
                        "Create",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildPackButton(
    int value,
    String label,
    int currentSelected,
    Function(int) onSelect,
  ) {
    final isSelected = currentSelected == value;
    return GestureDetector(
      onTap: () => onSelect(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey.shade200,
          border: Border.all(
            color: isSelected ? Colors.green.shade700 : Colors.grey.shade400,
            width: 1.4,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Name and Phone are required"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    ref.read(customerControllerProvider.notifier).addCustomer(
          context,
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          email: emailController.text.trim(),
          serviceType: '$selectedPack Month',
        );

        
  }
}
