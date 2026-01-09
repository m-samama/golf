// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../controllers/details_controller.dart';
// import '../../controllers/customer_controller.dart';
// import '../../models/storage_models.dart';
// import '../../config/app_routes.dart';

// class PlayingScreen extends ConsumerStatefulWidget {
//   const PlayingScreen({super.key});

//   @override
//   ConsumerState<PlayingScreen> createState() => _PlayingScreenState();
// }

// class _PlayingScreenState extends ConsumerState<PlayingScreen> {
//   final DetailsController dc = Get.put(DetailsController());

//   List<dynamic> playingCustomers = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();

//     // Ensure context + provider ready
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchPlayingCustomers();
//     });
//   }

//   Future<void> _fetchPlayingCustomers() async {
//     final controller = ref.read(customerControllerProvider.notifier);
//     final allCustomers = await controller.getAllCustomers(context);

//     setState(() {
//       // Filter only "Playing" customers
//       playingCustomers = allCustomers
//           .where(
//             (c) => (c['status']?.toString().toLowerCase() ?? '') == 'playing',
//           )
//           .toList();
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Playing'),
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
//                       onRefresh: _fetchPlayingCustomers,
//                       child: playingCustomers.isEmpty
//                           ? const Center(
//                               child: Text(
//                                 'No playing customers found.',
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             )
//                           : ListView.separated(
//                               itemCount: playingCustomers.length,
//                               separatorBuilder: (_, __) =>
//                                   const SizedBox(height: 10),
//                               itemBuilder: (context, idx) {
//                                 final c = playingCustomers[idx];
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
//                                       'Playing',
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
import '../../controllers/customer_controller.dart';
import '../../controllers/details_controller.dart';
import '../../controllers/search_controller.dart'; // ✅ new
import '../../models/storage_models.dart';
import '../../config/app_routes.dart';

class PlayingScreen extends ConsumerStatefulWidget {
  const PlayingScreen({super.key});

  @override
  ConsumerState<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends ConsumerState<PlayingScreen> {
  final DetailsController dc = Get.put(DetailsController());
  final TextEditingController _searchCtrl = TextEditingController();

  bool isSearching = false;
  List<dynamic> playingCustomers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPlayingCustomers();
    });
  }

  // 🔹 Fetch only "Playing" customers via SearchRepo
  /// Fetch all customers with "Overdue" status
  Future<void> _fetchPlayingCustomers() async {
    setState(() => isLoading = true);
    final controller = ref.read(customerControllerProvider.notifier);
    final allCustomers = await controller.getAllCustomers(context);

    setState(() {
      playingCustomers = allCustomers.where((c) {
        final status = c['status']?.toString().toLowerCase().trim() ?? '';
        return status.contains('playing');
      }).toList();
      isLoading = false;
    });
  }

  /// 🔍 Search overdue customers by name/phone
  Future<void> _searchPlaying(String query) async {
    if (query.isEmpty) {
      _fetchPlayingCustomers();
      return;
    }

    setState(() => isSearching = true);

    final controller = ref.read(searchControllerProvider.notifier);
    await controller.searchCustomers(
      context: context,
      search: query,
      status: "playing", // ✅ Filter by overdue
    );

    final searchState = ref.read(searchControllerProvider);
    searchState.whenData((data) {
      setState(() {
        playingCustomers = data;
        isSearching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playing'),
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
              controller: _searchCtrl,
              onChanged: _searchPlaying,
              decoration: InputDecoration(
                hintText: 'Search by name or phone number',
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

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => _fetchPlayingCustomers(),
                      child: playingCustomers.isEmpty
                          ? const Center(
                              child: Text(
                                'No playing customers found.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.separated(
                              itemCount: playingCustomers.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, idx) {
                                final c = playingCustomers[idx];
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
                                      'Playing',
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
    Color bgColor = Colors.green.shade50;
    Color textColor = Colors.green.shade700;
    IconData icon = Icons.play_arrow;

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
