// lib/app/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lapor_tawuran/app/controllers/home_controller.dart';
import 'package:lapor_tawuran/app/routes/app_pages.dart';
import 'package:lapor_tawuran/app/views/my_reports_view.dart';
import 'package:lapor_tawuran/app/views/profile_view.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      buildMapView(),
      const MyReportsView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTabIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Peta',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Laporan Saya',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMapView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Laporan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Waktu',
            onPressed: () => controller.showFilterDialog(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        child: Obx(() {
          if (controller.isLoading.value && controller.reports.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(-7.3909, 109.3630),
              initialZoom: 11.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.lapor_tawuran',
              ),
              MarkerLayer(
                markers: controller.zoneMarkers.toList(),
              ),
              MarkerLayer(
                markers: controller.iconMarkers.toList(),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_REPORT);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}