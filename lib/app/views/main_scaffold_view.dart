import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:lapor_tawuran/app/controllers/auth_controller.dart';
import 'package:lapor_tawuran/app/controllers/home_controller.dart';
import 'package:lapor_tawuran/app/controllers/location_controller.dart';
import 'package:lapor_tawuran/app/controllers/profile_controller.dart';
import 'package:lapor_tawuran/app/views/admin/history_view.dart';
import 'package:lapor_tawuran/app/views/admin/verification_list_view.dart';
import 'package:lapor_tawuran/app/views/home_view.dart';
import 'package:lapor_tawuran/app/views/my_reports_view.dart';
import 'package:lapor_tawuran/app/views/profile_view.dart';

class MainScaffoldView extends GetView<HomeController> {
  MainScaffoldView({Key? key}) : super(key: key);

  final AuthController authController = Get.find<AuthController>();
  final LocationController locationController = Get.find<LocationController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    // Tentukan halaman dan ikon berdasarkan peran pengguna
    final bool isAdmin = authController.isAdmin.value;

    final List<Widget> pages = isAdmin
        ? [
            // Halaman untuk Admin
            const VerificationListView(),
            const HistoryView(),
            const ProfileView(),
          ]
        : [
            // Halaman untuk Pengguna Biasa
            HomeViewContent(),
            const MyReportsView(),
            const Center(child: Text("About Me Page")),
            const ProfileView(),
          ];

    final iconList = isAdmin
        ? <IconData>[
            // Ikon untuk Admin
            Icons.pending_actions,
            Icons.history,
            Icons.person,
          ]
        : <IconData>[
            // Ikon untuk Pengguna Biasa
            Icons.home_filled,
            Icons.article,
            Icons.info,
            Icons.person,
          ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Obx(() {
                final photoUrl = profileController.userProfile.value?.photoUrl;
                return CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                );
              }),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Current location",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12)),
                    Obx(() => Text(
                          locationController.currentAddress.value,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Obx(() {
        // Pastikan tabIndex tidak melebihi jumlah halaman yang ada
        final int activeIndex = controller.tabIndex.value < pages.length
            ? controller.tabIndex.value
            : 0;
        return IndexedStack(
          index: activeIndex,
          children: pages,
        );
      }),
      bottomNavigationBar: Obx(
        () => AnimatedBottomNavigationBar(
          icons: iconList,
          activeIndex: controller.tabIndex.value < pages.length
              ? controller.tabIndex.value
              : 0,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.smoothEdge,
          onTap: (index) => controller.changeTabIndex(index),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Colors.grey,
          backgroundColor: Colors.white,
          borderColor: Colors.grey.shade200,
          borderWidth: 1.5,
          shadow: BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ),
      ),
    );
  }
}