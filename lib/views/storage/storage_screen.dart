// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../controllers/details_controller.dart';
// import '../../controllers/storage_controller.dart';
// import '../../controllers/customer_controller.dart';
// import '../../config/app_routes.dart';
// import '../../models/storage_models.dart';

// class StorageScreen extends ConsumerStatefulWidget {
//   const StorageScreen({super.key});

//   @override
//   ConsumerState<StorageScreen> createState() => _StorageScreenState();
// }

// class _StorageScreenState extends ConsumerState<StorageScreen> {
//   final StorageController sc = Get.put(StorageController());
//   final DetailsController dc = Get.put(DetailsController());
//   final TextEditingController _searchCtrl = TextEditingController();
//   Timer? _debounce;
//   bool isLoadingLocal = false;
//   final String statusFilter = 'Storage'; // show only Storage
//   List<dynamic> storageCustomers = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _performSearch(''); // load initial list for status
//     _searchCtrl.addListener(_onSearchChanged);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchCustomers();
//     });
//   }

//   Future<void> _fetchCustomers() async {
//     final controller = ref.read(customerControllerProvider.notifier);
//     final allCustomers = await controller.getAllCustomers(context);
//     setState(() {
//       storageCustomers = allCustomers
//           .where(
//             (c) => (c['status']?.toString().toLowerCase() ?? '') == 'storage',
//           )
//           .toList();
//       isLoading = false;
//     });
//   }

//   @override
//   void dispose() {
//     _searchCtrl.removeListener(_onSearchChanged);
//     _searchCtrl.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     final q = _searchCtrl.text.trim();
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       _performSearch(q);
//     });
//   }

//   Future<void> _performSearch(String query) async {
//     setState(() => isLoadingLocal = true);
//     final list = await ref.read(customerControllerProvider.notifier).searchCustomers(
//           context: context,
//           search: query,
//           status: statusFilter,
//           page: 1,
//           limit: 50,
//         );
//     if (mounted) {
//       setState(() {
//         searchCustomers = storageCustomers
//           .where(
//             (c) => (c['status']?.toString().toLowerCase() ?? '') == 'storage',
//           )
//           .toList();
//       isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Storage'),
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
//             // Search bar
//             TextField(
//               controller: _searchCtrl,
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
//                       onRefresh: _fetchCustomers,
//                       child: storageCustomers.isEmpty
//                           ? const Center(
//                               child: Text(
//                                 'No customers found.',
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             )
//                           : ListView.separated(
//                               itemCount: storageCustomers.length,
//                               separatorBuilder: (_, __) =>
//                                   const SizedBox(height: 10),
//                               itemBuilder: (context, idx) {
//                                 final c = storageCustomers[idx];
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
//                                       'Storage',
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
//     // 🔹 Normalize status (remove spaces, lowercase)
//     final normalizedStatus = status.trim().toLowerCase();

//     // 🔹 Default colors and icons
//     Color bgColor = Colors.purple.shade50;
//     Color textColor = Colors.purple.shade700;
//     IconData icon = Icons.storage_rounded;

//     // 🔹 Match using contains for flexible comparison
//     if (normalizedStatus.contains('overdue')) {
//       bgColor = Colors.red.shade50;
//       textColor = Colors.red.shade700;
//       icon = Icons.warning_amber_rounded;
//     } else if (normalizedStatus.contains('takeoff') ||
//         normalizedStatus.contains('take off')) {
//       bgColor = Colors.orange.shade50;
//       textColor = Colors.orange.shade700;
//       icon = Icons.flight_takeoff;
//     } else if (normalizedStatus.contains('playing')) {
//       bgColor = Colors.green.shade50;
//       textColor = Colors.green.shade700;
//       icon = Icons.play_arrow;
//     } else if (normalizedStatus.contains('storage')) {
//       bgColor = Colors.purple.shade50;
//       textColor = Colors.purple.shade700;
//       icon = Icons.storage_rounded;
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
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../controllers/details_controller.dart';
import '../../controllers/search_controller.dart';
import '../../models/storage_models.dart';
import '../../config/app_routes.dart';

class StorageScreen extends ConsumerStatefulWidget {
  const StorageScreen({super.key});

  @override
  ConsumerState<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends ConsumerState<StorageScreen> {
  // 🔹 Use existing shared DetailsController
  final DetailsController dc = Get.put(DetailsController());
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;

  // 🔹 Storage-specific filter
  final String statusFilter = 'storage';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performSearch(''); // initial load
    });
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // 🔹 Debounced search input
  void _onSearchChanged() {
    final query = _searchCtrl.text.trim();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  // 🔹 Perform search using SearchController
  Future<void> _performSearch(String query) async {
    await ref.read(searchControllerProvider.notifier).searchCustomers(
          context: context,
          search: query.isEmpty ? null : query,
          status: statusFilter,
          page: 1,
          limit: 50,
        );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage'),
        leading: IconButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (route) => false,
          ),
          icon: const Icon(Icons.arrow_back_ios_new),
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
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search name or phone number',
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

            // 🔹 Search Results
            Expanded(
              child: searchState.when(
                data: (customers) {
                  // Filter by Storage status just in case API returns mixed
                  final storageOnly = customers
                      .where((c) =>
                          (c['status']?.toString().toLowerCase() ?? '') ==
                          statusFilter)
                      .toList();

                  if (storageOnly.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Storage customers found.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => _performSearch(_searchCtrl.text),
                    child: ListView.separated(
                      itemCount: storageOnly.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final c = storageOnly[i];
                        return _listCard(
                          name: c['customer_name'] ?? 'Unknown',
                          phone: c['phone'] ?? '-',
                          email: c['email'] ?? '',
                          status: c['status'] ?? 'N/A',
                          createdAt: c['created_at'] ?? '',
                          updatedAt: c['updated_at'] ?? '',
                          onTap: () {
                            // 🔹 Set Storage item in shared DetailsController
                            dc.setItem(
                              StorageItem(
                                id: c['id']?.toString() ?? '',
                                name: c['customer_name'] ?? 'Unknown',
                                phone: c['phone'] ?? '-',
                                dateRange: '',
                                status: c['status']?.toString() ?? 'N/A',
                                image: 'assets/images/user.png',
                                checkInDate:
                                    c['checkin_date']?.toString() ?? '',
                                packageDuration:
                                    c['package']?.toString() ?? '',
                                position: c['position']?.toString() ?? '',
                                clubsCount: int.tryParse(
                                        c['bag_count']?.toString() ?? '0') ??
                                    0,
                              ),
                              'Storage',
                            );
                            Navigator.pushNamed(context, AppRoutes.details);
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => const Center(
                    child: Text('Error: No internet Connection')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🎨 Card Widget for customer display
  Widget _listCard({
    required String name,
    required String phone,
    required String email,
    required String status,
    required VoidCallback onTap,
    String createdAt = '',
    String updatedAt = '',
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
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style:
                          const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(phone, style: TextStyle(color: Colors.grey.shade600)),
                  if (email.isNotEmpty)
                    Text(email,
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (createdAt.isNotEmpty && updatedAt.isNotEmpty) ...[
                  Text(
                    '${createdAt.split(' ').first} - ${updatedAt.split(' ').first}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
