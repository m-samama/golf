// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../config/app_routes.dart';
// import '../../controllers/details_controller.dart';
// import '../../controllers/customer_controller.dart';
// import '../../models/storage_models.dart';

// class DetailsScreen extends ConsumerStatefulWidget {
//   const DetailsScreen({super.key});

//   @override
//   ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
// }

// class _DetailsScreenState extends ConsumerState<DetailsScreen> {
//   final DetailsController dc = Get.put(DetailsController());
//   Map<String, dynamic>? customerData;
//   List<dynamic>? clubBags;
//   List<Map<String, dynamic>> selectedBags = [];
//   bool isLoading = true;
//   bool isClubLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _fetchCustomerDetails();
//       await _fetchClubBags(); // ✅ Fetch club bags as soon as screen loads
//     });
//   }

//   Future<void> _fetchCustomerDetails() async {
//     final item = dc.selected.value;
//     if (item == null) return;

//     final res = await ref
//         .read(customerControllerProvider.notifier)
//         .getCustomerDetails(context, item.id);

//     if (mounted) {
//       setState(() {
//         customerData = res ?? {};
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _fetchClubBags() async {
//     try {
//       final res = await ref
//           .read(customerControllerProvider.notifier)
//           .getClubBags(context);
//       if (mounted) {
//         setState(() {
//           clubBags = res;
//           isClubLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => isClubLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final StorageItem? item = dc.selected.value;
//     final src = dc.sourcePage.value;

//     if (item == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text('Details')),
//         body: const Center(child: Text('No item selected')),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Customer Details'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new),
//           onPressed: () => _handleBackNavigation(context),
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : customerData == null
//           ? const Center(child: Text('Failed to load customer details'))
//           : _buildDetailsBody(item, src),
//       bottomNavigationBar: _buildBottomButtons(src),
//     );
//   }

//   void _handleBackNavigation(BuildContext context) {
//     final src = dc.sourcePage.value;
//     switch (src) {
//       case 'Storage':
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           AppRoutes.storage,
//           (_) => false,
//         );
//         break;
//       case 'Playing':
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           AppRoutes.playing,
//           (_) => false,
//         );
//         break;
//       case 'Overdue':
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           AppRoutes.overdue,
//           (_) => false,
//         );
//         break;
//       case 'TakeOff':
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           AppRoutes.takeoff,
//           (_) => false,
//         );
//         break;
//       default:
//         Navigator.pop(context);
//     }
//   }

//   Widget _buildDetailsBody(StorageItem item, String src) {
//     final c = customerData!;
//     final status = c['status'] ?? item.status;

//     Color chipBg;
//     Color chipText;
//     IconData? chipIcon;

//     switch (status) {
//       case 'Playing':
//         chipBg = Colors.green.shade50;
//         chipText = Colors.green.shade700;
//         chipIcon = Icons.play_arrow;
//         break;
//       case 'Overdue':
//         chipBg = Colors.red.shade50;
//         chipText = Colors.red.shade700;
//         chipIcon = Icons.schedule;
//         break;
//       case 'TakeOff':
//         chipBg = Colors.grey.shade200;
//         chipText = Colors.grey.shade700;
//         chipIcon = Icons.remove_circle_outline;
//         break;
//       default:
//         chipBg = Colors.grey.shade100;
//         chipText = Colors.black87;
//         chipIcon = Icons.info_outline;
//     }

//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ---- Header ----
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const CircleAvatar(
//                 radius: 36,
//                 backgroundImage: AssetImage('assets/images/profile.jpeg'),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       c['customer_name'] ?? 'Unknown',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text('Phone: ${c['phone'] ?? '-'}'),
//                     if (c['email'] != null && c['email'].toString().isNotEmpty)
//                       Text('Email: ${c['email']}'),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: chipBg,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(chipIcon, color: chipText, size: 16),
//                     const SizedBox(width: 4),
//                     Text(
//                       status,
//                       style: TextStyle(
//                         color: chipText,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
// // ---- TOP BUTTONS ----
// if (src == 'Storage')
//   SizedBox(
//     width: double.infinity,
//     child: ElevatedButton(
//       onPressed: () async {
//         if (customerData != null && customerData!['id'] != null) {
//           final result = await Navigator.pushNamed(
//             context,
//             AppRoutes.editcustomer,
//             arguments: {'customerId': customerData!['id'].toString()},
//           );

//           // ✅ After returning from edit screen, check if data was updated
//           if (result == true) {
//             _fetchCustomerDetails(); // re-fetch updated customer details
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Customer ID not found')),
//           );
//         }
//       },

//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.grey.shade200,
//         foregroundColor: Colors.black,
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       child: const Text('Edit'),
//     ),
//   )
// else
//   Row(
//     children: [
//       Expanded(
//         flex: 6,
//         child: ElevatedButton.icon(
//           onPressed: () {},
//           icon: const Icon(Icons.print, color: Colors.white),
//           label: const Text(
//             'Print information',
//             style: TextStyle(color: Colors.white),
//           ),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green.shade700,
//             padding: const EdgeInsets.symmetric(vertical: 14),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//       ),
//       const SizedBox(width: 12),
//       Expanded(
//         flex: 4,
//         child: SizedBox(
//           height: 48,
//           child: ElevatedButton(
//             onPressed: src == 'TakeOff'
//                 ? () async {
//                     final confirm = await showDialog<bool>(
//                       context: context,
//                       builder: (_) => AlertDialog(
//                         title: const Text('Confirm Delete'),
//                         content: const Text(
//                           'Are you sure you want to delete this customer?',
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () =>
//                                 Navigator.pop(context, false),
//                             child: const Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () => Navigator.pushNamed(
//                               context,
//                               AppRoutes.dashboard,
//                             ),
//                             child: const Text(
//                               'Delete',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );

//                     if (confirm == true && customerData != null) {
//                       await ref
//                           .read(customerControllerProvider.notifier)
//                           .deleteCustomer(
//                             context,
//                             customerData!['id'].toString(),
//                           );
//                     }
//                   }
//                 : () {
//                     // Existing Edit logic
//                     if (customerData != null &&
//                         customerData!['id'] != null) {
//                       Navigator.pushNamed(
//                         context,
//                         AppRoutes.editcustomer,
//                         arguments: {
//                           'customerId': customerData!['id']
//                               .toString(),
//                         },
//                       );
//                     }
//                   },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: src == 'TakeOff'
//                   ? Colors.grey.shade200
//                   : Colors.grey.shade200,
//               foregroundColor: src == 'TakeOff'
//                   ? Colors.black
//                   : Colors.black,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text(src == 'TakeOff' ? 'Delete' : 'Edit'),
//           ),
//         ),
//       ),
//     ],
//   ),

// const SizedBox(height: 18),

//           // ---- Summary ----
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade50,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _infoTile('Check-in date', _formatDate(c['created_at'] ?? '-')),
//                 _verticalDivider(),
//                 _infoTile('Package', c['service_type'] ?? '-'),
//                 _verticalDivider(),
//                 _infoTile('Position', c['bag_type'] ?? '-'),
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),

//           // ---- Club Bags ----
//           if (src == 'Storage') ...[
//             const Text(
//               'Select Club Bags',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//             ),
//             const SizedBox(height: 10),
//             if (isClubLoading)
//               const Center(child: CircularProgressIndicator())
//             else if (clubBags == null || clubBags!.isEmpty)
//               const Text('No club bags found.')
//             else
//               _buildClubBagList(),
//             const SizedBox(height: 20),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildClubBagList() {
//     return Column(
//       children: clubBags!.map((bag) {
//         final bagId = bag['id'];
//         final bagName = bag['bag_type'] ?? 'Unnamed Bag';
//         final existing = selectedBags.firstWhere(
//           (b) => b['bag_id'] == bagId,
//           orElse: () => {},
//         );

//         final isSelected = existing.isNotEmpty;
//         final quantity = isSelected ? existing['quantity'] : 0;

//         return Container(
//           margin: const EdgeInsets.only(bottom: 10),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 6,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   image: const DecorationImage(
//                     image: AssetImage('assets/images/bag.jpg'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       bagName,
//                       style: const TextStyle(fontWeight: FontWeight.w700),
//                     ),
//                     Text(
//                       bag['brand'] ?? '',
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(
//                       Icons.remove_circle_outline,
//                       color: Colors.grey,
//                     ),
//                     onPressed: isSelected
//                         ? () {
//                             setState(() {
//                               final index = selectedBags.indexWhere(
//                                 (b) => b['bag_id'] == bagId,
//                               );
//                               if (index != -1) {
//                                 if (selectedBags[index]['quantity'] > 1) {
//                                   selectedBags[index]['quantity']--;
//                                 } else {
//                                   selectedBags.removeAt(index);
//                                 }
//                               }
//                             });
//                           }
//                         : null,
//                   ),
//                   Text(
//                     quantity.toString(),
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.add_circle_outline,
//                       color: Colors.green,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         final index = selectedBags.indexWhere(
//                           (b) => b['bag_id'] == bagId,
//                         );
//                         if (index != -1) {
//                           selectedBags[index]['quantity']++;
//                         } else {
//                           selectedBags.add({"bag_id": bagId, "quantity": 1});
//                         }
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _infoTile(String title, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         const SizedBox(height: 6),
//         Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
//       ],
//     );
//   }

//   String _formatDate(dynamic dateStr) {
//     if (dateStr == null || dateStr.toString().isEmpty) return '-';
//     try {
//       final date = DateTime.parse(dateStr.toString());
//       return "${date.day.toString().padLeft(2, '0')}/"
//           "${date.month.toString().padLeft(2, '0')}/"
//           "${date.year}";
//     } catch (_) {
//       return dateStr.toString().split(' ').first;
//     }
//   }

//   Widget _verticalDivider() =>
//       Container(height: 28, width: 1, color: Colors.grey.shade300);

//   Widget _buildBottomButtons(String src) {
//     List<Widget> buttons = [];
//     switch (src) {
//       case 'Storage':
//         buttons = [
//           Expanded(
//             child: OutlinedButton(
//               onPressed: () => Navigator.pushNamed(context, AppRoutes.storage),
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: Colors.red),
//                 foregroundColor: Colors.red,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//               child: const Text('Cancel'),
//             ),
//           ),
//           const SizedBox(width: 12),
//           _actionButton(
//             label: 'Check-In',
//             color: Colors.green,
//             onTap: () async {
//               if (selectedBags.isEmpty) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Please select at least one club bag'),
//                   ),
//                 );
//                 return;
//               }

//               final c = customerData!;
//               await ref
//                   .read(customerControllerProvider.notifier)
//                   .checkInCustomer(
//                     context,
//                     customerId: c['id'],
//                     package: c['service_type'] ?? 'Unknown Package',
//                     position: c['bag_type'] ?? 'N/A',
//                     clubBags: selectedBags,
//                   );
//             },
//           ),
//         ];
//         break;

//       case 'Playing':
//         buttons = [
//           _actionButton(
//             label: 'Return Clubs',
//             color: Colors.green,
//             onTap: () => _changeStatus('Storage', AppRoutes.storage),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: OutlinedButton(
//               onPressed: () => Navigator.pushNamed(context, AppRoutes.takeoff),
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: Colors.red),
//                 foregroundColor: Colors.red,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//               child: const Text('Take Off'),
//             ),
//           ),
//         ];
//         break;

//       case 'Overdue':
//         buttons = [
//           _actionButton(
//             label: 'Send Reminder',
//             color: Colors.red,
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Reminder sent successfully!')),
//               );
//             },
//           ),
//         ];
//         break;
//     }

//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(children: buttons),
//     );
//   }

//   Widget _actionButton({
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Expanded(
//       child: ElevatedButton(
//         onPressed: onTap,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }

//   void _changeStatus(String newStatus, String route) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Customer moved to $newStatus')));
//     Navigator.pushNamed(context, route);
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_routes.dart';
import '../../controllers/details_controller.dart';
import '../../controllers/customer_controller.dart';
import '../../models/storage_models.dart';

class DetailsScreen extends ConsumerStatefulWidget {
  const DetailsScreen({super.key});

  @override
  ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {
  final DetailsController dc = Get.put(DetailsController());
  Map<String, dynamic>? customerData;
  List<dynamic> assignedBags = []; // from API response (customer_club_bags)
  List<dynamic> allClubBags = []; // for Storage (selection)
  List<Map<String, dynamic>> selectedBags = [];
  bool isClubLoading = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Use addPostFrameCallback so GetX values are ready.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchCustomerDetails();

      // fetch club bags only when screen source is Storage
      if (dc.sourcePage.value == 'Storage') {
        await _fetchClubBags();
      } else {
        // still fetch assigned bags for other screens (customer_details already returns them)
        // _fetchCustomerDetails already filled assignedBags
        setState(() {
          isClubLoading = false; // no selection UI for non-storage
        });
      }
    });
  }

  Future<void> _fetchCustomerDetails() async {
    final item = dc.selected.value;
    if (item == null) return;

    final res = await ref
        .read(customerControllerProvider.notifier)
        .getCustomerDetails(context, item.id);

    if (mounted) {
      setState(() {
        customerData = res ?? {};
        assignedBags = (res?['customer_club_bags'] ?? []) as List;
        isLoading = false;
      });
    }
  }

  // 🔹 Fetch Club Bags (for STORAGE only)
  Future<void> _fetchClubBags() async {
    try {
      final res = await ref
          .read(customerControllerProvider.notifier)
          .getClubBags(context);
      if (mounted) {
        setState(() {
          allClubBags = res;
          isClubLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isClubLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final StorageItem? item = dc.selected.value;
    final src = dc.sourcePage.value;

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: const Center(child: Text('No item selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => _handleBackNavigation(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : customerData == null
          ? const Center(child: Text('Failed to load customer details'))
          : _buildDetailsBody(item, src),
      bottomNavigationBar: _buildBottomButtons(src),
    );
  }

  void _handleBackNavigation(BuildContext context) {
    final src = dc.sourcePage.value;
    switch (src) {
      case 'Storage':
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.storage,
          (_) => false,
        );
        break;
      case 'Playing':
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.playing,
          (_) => false,
        );
        break;
      case 'Overdue':
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.overdue,
          (_) => false,
        );
        break;
      case 'TakeOff':
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.takeoff,
          (_) => false,
        );
        break;
      default:
        Navigator.pop(context);
    }
  }

  Widget _buildDetailsBody(StorageItem item, String src) {
    final c = customerData!;
    final status = c['status'] ?? item.status;

    Color chipBg;
    Color chipText;
    IconData chipIcon;

    switch (status) {
      case 'Playing':
        chipBg = Colors.green.shade50;
        chipText = Colors.green.shade700;
        chipIcon = Icons.play_arrow;
        break;
      case 'Overdue':
        chipBg = Colors.red.shade50;
        chipText = Colors.red.shade700;
        chipIcon = Icons.schedule;
        break;
      case 'TakeOff':
        chipBg = Colors.grey.shade200;
        chipText = Colors.grey.shade700;
        chipIcon = Icons.remove_circle_outline;
        break;
      default:
        chipBg = Colors.grey.shade100;
        chipText = Colors.black87;
        chipIcon = Icons.info_outline;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundImage: AssetImage('assets/images/profile.jpeg'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c['customer_name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('Phone: ${c['phone'] ?? '-'}'),
                    if (c['email'] != null && c['email'].toString().isNotEmpty)
                      Text('Email: ${c['email']}'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(chipIcon, color: chipText, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        color: chipText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ---- TOP BUTTONS ----
          if (src == 'Storage')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (customerData != null && customerData!['id'] != null) {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoutes.editcustomer,
                      arguments: {'customerId': customerData!['id'].toString()},
                    );

                    // ✅ After returning from edit screen, check if data was updated
                    if (result == true) {
                      _fetchCustomerDetails(); // re-fetch updated customer details
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Customer ID not found')),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Edit'),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.print, color: Colors.white),
                    label: const Text(
                      'Print information',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: src == 'TakeOff'
                          ? () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                    'Are you sure you want to delete this customer?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        AppRoutes.dashboard,
                                      ),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true && customerData != null) {
                                await ref
                                    .read(customerControllerProvider.notifier)
                                    .deleteCustomer(
                                      context,
                                      customerData!['id'].toString(),
                                    );
                              }
                            }
                          : () {
                              // Existing Edit logic
                              if (customerData != null &&
                                  customerData!['id'] != null) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.editcustomer,
                                  arguments: {
                                    'customerId': customerData!['id']
                                        .toString(),
                                  },
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: src == 'TakeOff'
                            ? Colors.grey.shade200
                            : Colors.grey.shade200,
                        foregroundColor: src == 'TakeOff'
                            ? Colors.black
                            : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(src == 'TakeOff' ? 'Delete' : 'Edit'),
                    ),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 18),

          // --- Summary ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoTile('Check-in date', _formatDate(c['created_at'] ?? '-')),
                _verticalDivider(),
                _infoTile('Package', c['service_type'] ?? '-'),
                _verticalDivider(),
                _infoTile('Position', c['bag_type'] ?? '-'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- CLUB BAGS SECTION ---
          if (src == 'Storage') ...[
            const Text(
              'Select Club Bags',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            if (isClubLoading)
              const Center(child: CircularProgressIndicator())
            else if (allClubBags.isEmpty)
              const Text('No club bags available.')
            else
              Column(
                children: allClubBags.map((bag) {
                  final bagId = bag['id'];
                  final isSelected = selectedBags.any(
                    (b) => b['bag_id'] == bagId,
                  );
                  final quantity = isSelected
                      ? selectedBags.firstWhere(
                          (b) => b['bag_id'] == bagId,
                        )['quantity']
                      : 0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green.shade50
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                      border: Border.all(
                        color: isSelected
                            ? Colors.green
                            : Colors.transparent,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bag['bag_type'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if ((bag['brand'] ?? '').toString().isNotEmpty)
                                Text(
                                  bag['brand'],
                                  style: const TextStyle(color: Colors.grey),
                                ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: isSelected
                                  ? () {
                                      setState(() {
                                        final idx = selectedBags.indexWhere(
                                          (b) => b['bag_id'] == bagId,
                                        );
                                        if (idx != -1) {
                                          if (selectedBags[idx]['quantity'] >
                                              1) {
                                            selectedBags[idx]['quantity']--;
                                          } else {
                                            selectedBags.removeAt(idx);
                                          }
                                        }
                                      });
                                    }
                                  : null,
                            ),
                            Text(
                              quantity.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                setState(() {
                                  final idx = selectedBags.indexWhere(
                                    (b) => b['bag_id'] == bagId,
                                  );
                                  if (idx != -1) {
                                    selectedBags[idx]['quantity']++;
                                  } else {
                                    selectedBags.add({
                                      "bag_id": bagId,
                                      "quantity": 1,
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
          ] else ...[
            const Text(
              'Assigned Club Bags',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            if (assignedBags.isEmpty)
              const Text('No assigned club bags.')
            else
              Column(
                children: assignedBags.map((b) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          b['bag_type'] ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text('Qty: ${b['club_count'] ?? 0}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  // Widget _buildClubBagList() {
  //   return Column(
  //     children: allClubBags.map((bag) {
  //       final bagId = bag['id'];
  //       final bagName = bag['bag_type'] ?? 'Unnamed Bag';
  //       final existing = selectedBags.firstWhere(
  //         (b) => b['bag_id'] == bagId,
  //         orElse: () => {},
  //       );

  //       final isSelected = existing.isNotEmpty;
  //       final quantity = isSelected ? existing['quantity'] : 0;

  //       return Container(
  //         margin: const EdgeInsets.only(bottom: 10),
  //         padding: const EdgeInsets.all(12),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(12),
  //           boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
  //         ),
  //         child: Row(
  //           children: [
  //             Expanded(child: Text(bagName, style: const TextStyle(fontWeight: FontWeight.w700))),
  //             Row(
  //               children: [
  //                 IconButton(
  //                   icon: const Icon(Icons.remove_circle_outline),
  //                   onPressed: isSelected
  //                       ? () {
  //                           setState(() {
  //                             final index = selectedBags.indexWhere((b) => b['bag_id'] == bagId);
  //                             if (index != -1) {
  //                               if (selectedBags[index]['quantity'] > 1) {
  //                                 selectedBags[index]['quantity']--;
  //                               } else {
  //                                 selectedBags.removeAt(index);
  //                               }
  //                             }
  //                           });
  //                         }
  //                       : null,
  //                 ),
  //                 Text(quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
  //                 IconButton(
  //                   icon: const Icon(Icons.add_circle_outline, color: Colors.green),
  //                   onPressed: () {
  //                     setState(() {
  //                       final index = selectedBags.indexWhere((b) => b['bag_id'] == bagId);
  //                       if (index != -1) {
  //                         selectedBags[index]['quantity']++;
  //                       } else {
  //                         selectedBags.add({"bag_id": bagId, "quantity": 1});
  //                       }
  //                     });
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _infoTile(String title, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
    ],
  );

  String _formatDate(dynamic dateStr) {
    if (dateStr == null || dateStr.toString().isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr.toString());
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (_) {
      return dateStr.toString().split(' ').first;
    }
  }

  Widget _verticalDivider() =>
      Container(height: 28, width: 1, color: Colors.grey.shade300);

  Widget _buildBottomButtons(String src) {
    List<Widget> buttons = [];
    switch (src) {
      case 'Storage':
        buttons = [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.storage),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          _actionButton(
            label: 'Check-In',
            color: Colors.green,
            onTap: () async {
              if (selectedBags.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select at least one club bag'),
                  ),
                );
                return;
              }

              final c = customerData!;
              await ref
                  .read(customerControllerProvider.notifier)
                  .checkInCustomer(
                    context,
                    customerId: c['id'],
                    package: c['service_type'] ?? 'Unknown Package',
                    position: c['bag_type'] ?? 'N/A',
                    clubBags: selectedBags,
                  );
            },
          ),
        ];
        break;

      case 'Playing':
        buttons = [
          _actionButton(
            label: 'Return Clubs',
            color: Colors.green,
            onTap: () => _changeStatus('Storage', AppRoutes.storage),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.takeoff),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Take Off'),
            ),
          ),
        ];
        break;

      case 'Overdue':
        buttons = [
          _actionButton(
            label: 'Send Reminder',
            color: Colors.red,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reminder sent successfully!')),
              );
            },
          ),
        ];
        break;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(children: buttons),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void _changeStatus(String newStatus, String route) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Customer moved to $newStatus')));
    Navigator.pushNamed(context, route);
  }
}
