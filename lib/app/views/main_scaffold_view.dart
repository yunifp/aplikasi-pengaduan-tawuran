// lib/app/views/main_scaffold_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:lapor_tawuran/app/controllers/home_controller.dart';
import 'package:lapor_tawuran/app/controllers/location_controller.dart';
import 'package:lapor_tawuran/app/controllers/profile_controller.dart';
import 'package:lapor_tawuran/app/views/home_view.dart';
import 'package:lapor_tawuran/app/views/my_reports_view.dart';
import 'package:lapor_tawuran/app/views/profile_view.dart';

class MainScaffoldView extends GetView<HomeController> {
  MainScaffoldView({Key? key}) : super(key: key);

  final LocationController locationController = Get.find<LocationController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeViewContent(),
      const MyReportsView(),
      const Center(child: Text("About Me Page")),
      const ProfileView(),
    ];

    // Daftar ikon untuk navigasi
    final iconList = <IconData>[
      Icons.home_filled, // Home
      Icons.article,     // Riwayat
      Icons.info,        // About Me
      Icons.person,      // Profile
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
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(
        () => AnimatedBottomNavigationBar(
          icons: iconList,
          activeIndex: controller.tabIndex.value,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.smoothEdge,
          onTap: (index) => controller.changeTabIndex(index),
          // --- Kustomisasi Tampilan ---
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