// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../common/bottom_navbar.dart';
// import '../../config/app_routes.dart';
// import '../../controllers/auth_controller.dart';
// import '../../controllers/dashboard_controller.dart';
// import '../../models/dashboard_model.dart';

// class DashboardView extends ConsumerStatefulWidget {
//   const DashboardView({super.key});

//   @override
//   ConsumerState<DashboardView> createState() => _DashboardViewState();
// }

// class _DashboardViewState extends ConsumerState<DashboardView> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch user data once the screen is loaded
//     Future.microtask(() {
//       // ref.read(authControllerProvider.notifier).fetchUserData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final DashboardController controller = DashboardController();
//     final List<DashboardItem> items = controller.getDashboardItems();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildProfileHeader(),
//               const SizedBox(height: 25),
//               _buildBanner(),
//               const SizedBox(height: 30),
//               const Text(
//                 "Dashboard",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: items.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 15,
//                   mainAxisSpacing: 15,
//                   childAspectRatio: 1.05,
//                 ),
//                 itemBuilder: (context, index) {
//                   final item = items[index];
//                   return _dashboardCard(context, item);
//                 },
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: const BottomNavBar(),
//     );
//   }

//   // 🧩 Components
//   Widget _buildProfileHeader() {
//     final authState = ref.watch(authControllerProvider);

//     // final name = (authState.user?.name?.isNotEmpty ?? false)
//     //     ? authState.user!.name
//     //     : 'User';
//     return Row(
//       children: [
//         Stack(
//           children: [
//             const CircleAvatar(
//               radius: 30,
//               backgroundImage: AssetImage("assets/images/profile.jpeg"),
//             ),
//             Positioned(
//               top: 5,
//               right: 5,
//               child: Container(
//                 width: 12,
//                 height: 12,
//                 decoration: const BoxDecoration(
//                   color: Colors.green,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(width: 15),
//         // Text(
//         //       "Good morning $name!",
//         //       style: const TextStyle(
//         //         fontSize: 17,
//         //         fontWeight: FontWeight.w600,
//         //         color: Colors.black87,
//         //       ),
//         //     ),
//         Text(
//           "Good morning !",
//           style: const TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),

//         IconButton(
//           onPressed: () {
//             Navigator.pushNamed(context, AppRoutes.settings);
//           },
//           icon: const Icon(Icons.more_vert, color: Colors.black54, size: 24),
//         ),
//       ],
//     );
//   }

//   Widget _buildBanner() {
//     return Container(
//       height: 250,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         image: const DecorationImage(
//           image: AssetImage("assets/images/golf_banner.jpg"),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             top: 20,
//             left: 20,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black.withValues(alpha: 0.7),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Text(
//                 "Select Activity",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: Row(
//   children: [
//     Expanded(
//       child: _actionButton(
//         Colors.blue,
//         Icons.login,
//         "Check-in",
//         onPressed: () {
//           Navigator.pushNamed(context, AppRoutes.playing);
//         },
//       ),
//     ),
//     const SizedBox(width: 15),
//     Expanded(
//       child: _actionButton(
//         Colors.green,
//         Icons.sports_golf,
//         "Take Off",
//         onPressed: () {
//           Navigator.pushNamed(context, AppRoutes.takeoff);
//         },
//       ),
//     ),
//   ],
// ),

//           ),
//         ],
//       ),
//     );
//   }

//   Widget _actionButton(
//   Color color,
//   IconData icon,
//   String label, {
//   required VoidCallback onPressed,
// }) {
//   return InkWell(
//     onTap: onPressed,
//     borderRadius: BorderRadius.circular(15),
//     child: Container(
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//             child: Icon(icon, color: Colors.white, size: 18),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             label,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 15,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

//   Widget _dashboardCard(BuildContext context, DashboardItem item) {
//     return GestureDetector(
//       onTap: () {
//         String route;
//         switch (item.title) {
//           case 'STORAGE':
//             route = AppRoutes.storage;
//             break;
//           case 'PLAYING':
//             route = AppRoutes.playing;
//             break;
//           case 'OVERDUE':
//             route = AppRoutes.overdue;
//             break;
//           default:
//             route = AppRoutes.takeoff;
//         }

//         // ✅ Use Flutter Navigator instead of GetX
//         Navigator.pushNamed(context, route);
//       },
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: item.color,
//           borderRadius: BorderRadius.circular(18),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.black87,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(item.icon, color: Colors.white),
//             ),
//             const Spacer(),
//             Text(
//               item.title,
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black54,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               item.value,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/bottom_navbar.dart';
import '../../config/app_routes.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/get_name_controller.dart';
import '../../models/dashboard_model.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadDashboardData();
      ref.read(profileControllerProvider.notifier).getUserName();
    });
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    await ref.read(dashboardProvider.notifier).fetchDashboardCounts();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final dashboardItems = ref.watch(dashboardProvider);
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(profileAsync),
                const SizedBox(height: 25),
                _buildBanner(),
                const SizedBox(height: 30),
                const Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (dashboardItems.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Text(
                        "No data available.",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dashboardItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.05,
                        ),
                    itemBuilder: (context, index) {
                      final item = dashboardItems[index];
                      return _dashboardCard(context, item);
                    },
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildProfileHeader(AsyncValue<String?> profileAsync) {
    return profileAsync.when(
      data: (name) {
        return Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/images/profile.jpeg"),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "${name ?? 'Guest'}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black54,
                size: 24,
              ),
            ),
          ],
        );
      },
      loading: () => const Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("assets/images/profile.jpeg"),
          ),
          SizedBox(width: 15),
          CircularProgressIndicator(strokeWidth: 2),
        ],
      ),
      error: (err, _) {
        return Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage("assets/images/profile.jpeg"),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Guest",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black54,
                size: 24,
              ),
            ),
          ],
        );
      },
    );
  }

  /// 🕒 Greeting message based on time
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  // 🖼 Banner
  Widget _buildBanner() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage("assets/images/golf_banner.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Select Activity",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: _actionButton(
                    Colors.blue,
                    Icons.login,
                    "Check-in",
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.playing);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _actionButton(
                    Colors.green,
                    Icons.sports_golf,
                    "Take Off",
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.takeoff);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    Color color,
    IconData icon,
    String label, {
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(BuildContext context, DashboardItem item) {
    return GestureDetector(
      onTap: () {
        String route;
        switch (item.title.toUpperCase()) {
          case 'STORAGE':
            route = AppRoutes.storage;
            break;
          case 'PLAYING':
            route = AppRoutes.playing;
            break;
          case 'OVERDUE':
            route = AppRoutes.overdue;
            break;
          default:
            route = AppRoutes.takeoff;
        }
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: Colors.white),
            ),
            const Spacer(),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
