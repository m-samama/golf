// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../controllers/details_controller.dart';
// import '../../controllers/customer_controller.dart';
// import '../../models/storage_models.dart';
// import '../../config/app_routes.dart';

// class TakeOffScreen extends ConsumerStatefulWidget {
//   const TakeOffScreen({super.key});

//   @override
//   ConsumerState<TakeOffScreen> createState() => _TakeOffScreenState();
// }

// class _TakeOffScreenState extends ConsumerState<TakeOffScreen> {
//   final DetailsController dc = Get.put(DetailsController());

//   List<dynamic> takeOffCustomers = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchTakeOffCustomers();
//     });
//   }

//   Future<void> _fetchTakeOffCustomers() async {
//     final controller = ref.read(customerControllerProvider.notifier);
//     final allCustomers = await controller.getAllCustomers(context);

//     setState(() {
//       takeOffCustomers = allCustomers.where((c) {
//         final status = c['status']?.toString().toLowerCase().trim() ?? '';
//         return status.contains('takeoff') || status.contains('take off');
//       }).toList();

//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Take Off'),
//         leading: IconButton(
//           onPressed: () => Navigator.pushNamedAndRemoveUntil(
//             context,
//             AppRoutes.dashboard,
//             (route) => false,
//           ),
//           icon: Icon(Icons.arrow_back),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // 🔍 Search bar
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search name or phone number',
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.grey.shade100,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: const [
//                 Text('Recent', style: TextStyle(fontWeight: FontWeight.w600)),
//                 SizedBox(width: 8),
//                 Icon(Icons.filter_list, size: 18, color: Colors.grey),
//               ],
//             ),
//             const SizedBox(height: 10),

//             // 🔹 List of Customers
//             Expanded(
//               child: isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : RefreshIndicator(
//                       onRefresh: _fetchTakeOffCustomers,
//                       child: takeOffCustomers.isEmpty
//                           ? const Center(
//                               child: Text(
//                                 'No TakeOff customers found.',
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             )
//                           : ListView.separated(
//                               itemCount: takeOffCustomers.length,
//                               separatorBuilder: (_, __) =>
//                                   const SizedBox(height: 10),
//                               itemBuilder: (context, idx) {
//                                 final c = takeOffCustomers[idx];
//                                 return _listCard(
//                                   name: c['customer_name'] ?? 'Unknown',
//                                   phone: c['phone'] ?? '-',
//                                   email: c['email'] ?? '',
//                                   status: c['status'] ?? 'N/A',
//                                   createdAt: c['created_at'] ?? '',
//                                   updated_at: c['updated_at'] ?? '',
//                                   onTap: () {
//                                     dc.setItem(
//                                       StorageItem(
//                                         id: c['id']?.toString() ?? '',
//                                         name: c['customer_name'] ?? 'Unknown',
//                                         phone: c['phone'] ?? '-',
//                                         dateRange: '',
//                                         status:
//                                             c['status']?.toString() ?? 'N/A',
//                                         image: 'assets/images/user.png',
//                                         checkInDate:
//                                             c['checkin_date']?.toString() ?? '',
//                                         packageDuration:
//                                             c['package']?.toString() ?? '',
//                                         position:
//                                             c['position']?.toString() ?? '',
//                                         clubsCount:
//                                             int.tryParse(
//                                               c['bag_count']?.toString() ?? '0',
//                                             ) ??
//                                             0,
//                                       ),
//                                       'TakeOff',
//                                     );
//                                     Navigator.pushNamed(
//                                       context,
//                                       AppRoutes.details,
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _listCard({
//     required String name,
//     required String phone,
//     required String email,
//     required String status,
//     required VoidCallback onTap,
//     String createdAt = '',
//     String updated_at = '',
//   }) {
//     // 🔹 Status-based color & icon logic
//     Color bgColor;
//     Color textColor;
//     IconData icon;

//     switch (status.toLowerCase()) {
//       case 'overdue':
//         bgColor = Colors.red.shade50;
//         textColor = Colors.red.shade700;
//         icon = Icons.warning_amber_rounded;
//         break;
//       case 'takeoff':
//       case 'take off':
//         bgColor = Colors.orange.shade50;
//         textColor = Colors.orange.shade700;
//         icon = Icons.flight_takeoff;
//         break;
//       case 'playing':
//         bgColor = Colors.green.shade50;
//         textColor = Colors.green.shade700;
//         icon = Icons.play_arrow;
//         break;
//       default:
//         bgColor = Colors.purple.shade50;
//         textColor = Colors.purple.shade700;
//         icon = Icons.storage_rounded;
//     }

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // 👤 Avatar
//             Container(
//               width: 56,
//               height: 56,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Icon(Icons.person, size: 30, color: Colors.grey),
//             ),
//             const SizedBox(width: 12),

//             // 📋 Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(fontWeight: FontWeight.w700),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(phone, style: TextStyle(color: Colors.grey.shade600)),
//                   if (email.isNotEmpty)
//                     Text(
//                       email,
//                       style: TextStyle(
//                         color: Colors.grey.shade500,
//                         fontSize: 12,
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             // 📅 Date + Status
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 if (createdAt.isNotEmpty && updated_at.isNotEmpty) ...[
//                   Text(
//                     '${createdAt.split(' ').first} - ${updated_at.split(' ').first}',
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.grey[600],
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                 ],
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: bgColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(icon, size: 14, color: textColor),
//                       const SizedBox(width: 4),
//                       Text(
//                         status,
//                         style: TextStyle(
//                           color: textColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/details_controller.dart';
import '../../controllers/customer_controller.dart';
import '../../controllers/search_controller.dart'; // ✅ import search controller
import '../../models/storage_models.dart';
import '../../config/app_routes.dart';

class TakeOffScreen extends ConsumerStatefulWidget {
  const TakeOffScreen({super.key});

  @override
  ConsumerState<TakeOffScreen> createState() => _TakeOffScreenState();
}

class _TakeOffScreenState extends ConsumerState<TakeOffScreen> {
  final DetailsController dc = Get.put(DetailsController());
  final TextEditingController searchController = TextEditingController();

  List<dynamic> takeOffCustomers = [];
  bool isLoading = true;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTakeOffCustomers();
    });
  }

  Future<void> _fetchTakeOffCustomers() async {
    setState(() => isLoading = true);
    final controller = ref.read(customerControllerProvider.notifier);
    final allCustomers = await controller.getAllCustomers(context);

    setState(() {
      takeOffCustomers = allCustomers.where((c) {
        final status = c['status']?.toString().toLowerCase().trim() ?? '';
        return status.contains('takeoff') || status.contains('take off');
      }).toList();
      isLoading = false;
    });
  }

  Future<void> _searchTakeOff(String query) async {
    if (query.isEmpty) {
      _fetchTakeOffCustomers();
      return;
    }

    setState(() {
      isSearching = true;
    });

    final controller = ref.read(searchControllerProvider.notifier);
    await controller.searchCustomers(
      context: context,
      search: query,
      status: "Take Off", // ✅ Only fetch takeoff customers
    );

    final searchState = ref.read(searchControllerProvider);
    searchState.whenData((data) {
      setState(() {
        takeOffCustomers = data;
        isSearching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Off'),
        leading: IconButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (route) => false,
          ),
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Search bar
            TextField(
              controller: searchController,
              onChanged: _searchTakeOff, // ✅ search as user types
              decoration: InputDecoration(
                hintText: 'Search Take Off customers by name or phone',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: const [
                Text('Recent', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(width: 8),
                Icon(Icons.filter_list, size: 18, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 10),

            // 🔹 List of Customers
            Expanded(
              child: (isLoading || isSearching)
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _fetchTakeOffCustomers,
                      child: takeOffCustomers.isEmpty
                          ? const Center(
                              child: Text(
                                'No Take Off customers found.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.separated(
                              itemCount: takeOffCustomers.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, idx) {
                                final c = takeOffCustomers[idx];
                                return _listCard(
                                  name: c['customer_name'] ?? 'Unknown',
                                  phone: c['phone'] ?? '-',
                                  email: c['email'] ?? '',
                                  status: c['status'] ?? 'N/A',
                                  createdAt: c['created_at'] ?? '',
                                  updated_at: c['updated_at'] ?? '',
                                  onTap: () {
                                    dc.setItem(
                                      StorageItem(
                                        id: c['id']?.toString() ?? '',
                                        name: c['customer_name'] ?? 'Unknown',
                                        phone: c['phone'] ?? '-',
                                        dateRange: '',
                                        status:
                                            c['status']?.toString() ?? 'N/A',
                                        image: 'assets/images/user.png',
                                        checkInDate:
                                            c['checkin_date']?.toString() ?? '',
                                        packageDuration:
                                            c['package']?.toString() ?? '',
                                        position:
                                            c['position']?.toString() ?? '',
                                        clubsCount:
                                            int.tryParse(
                                              c['bag_count']?.toString() ?? '0',
                                            ) ??
                                            0,
                                      ),
                                      'TakeOff',
                                    );
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.details,
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                    
            ),
          ],
        ),
      ),
    );
  }

  Widget _listCard({
    required String name,
    required String phone,
    required String email,
    required String status,
    required VoidCallback onTap,
    String createdAt = '',
    String updated_at = '',
  }) {
      Color bgColor = Colors.purple.shade50;
    Color textColor = Colors.purple.shade700;
    IconData icon = Icons.storage_rounded;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 👤 Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, size: 30, color: Colors.grey),
            ),
            const SizedBox(width: 12),

            // 📋 Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(phone, style: TextStyle(color: Colors.grey.shade600)),
                  if (email.isNotEmpty)
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),

            // 📅 Date + Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (createdAt.isNotEmpty && updated_at.isNotEmpty) ...[
                  Text(
                    '${createdAt.split(' ').first} - ${updated_at.split(' ').first}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 14, color: textColor),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
