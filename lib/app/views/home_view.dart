// lib/app/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lapor_tawuran/app/controllers/home_controller.dart';
import 'package:lapor_tawuran/app/controllers/profile_controller.dart';
import 'package:lapor_tawuran/app/routes/app_pages.dart';

class HomeViewContent extends GetView<HomeController> {
  HomeViewContent({Key? key}) : super(key: key);

  final ProfileController profileController = Get.find<ProfileController>();

  void showMapDialog() {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: SizedBox(
          height: Get.height * 0.75,
          width: Get.width,
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  child: FlutterMap(
                    options: const MapOptions(
                      initialCenter: LatLng(-7.3909, 109.3630),
                      initialZoom: 11.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.lapor_tawuran',
                      ),
                      Obx(() =>
                          MarkerLayer(markers: controller.zoneMarkers.toList())),
                      Obx(() =>
                          MarkerLayer(markers: controller.iconMarkers.toList())),
                    ],
                  ),
                ),
              ),
              TextButton(
                child: const Text("Tutup"),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // RefreshIndicator dan SingleChildScrollView adalah kunci agar halaman bisa di-scroll
    return RefreshIndicator(
      onRefresh: () => controller.refreshData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // Memastikan scrolling selalu aktif
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          final userName = profileController
                                  .userProfile.value?.name
                                  .split(' ')
                                  .first ??
                              'Pengguna';
                          return Text(
                            "Hai, $userName,",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          );
                        }),
                        const Text(
                          "bagaimana lokasi disekitarmu?",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Laporkan kejadian tawuran atau gangster yang meresahkan di lokasi anda",
                          style: TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      'assets/home_illustration.png', // Pastikan path gambar ini benar
                      height: 120,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Peta Laporan",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    tooltip: 'Filter Waktu',
                    onPressed: () => controller.showFilterDialog(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: showMapDialog,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C4E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AbsorbPointer(
                      child: Obx(() {
                        if (controller.isLoading.value &&
                            controller.reports.isEmpty) {
                          return const Center(
                              child:
                                  CircularProgressIndicator(color: Colors.white));
                        }
                        return FlutterMap(
                          options: const MapOptions(
                            initialCenter: LatLng(-7.3909, 109.3630),
                            initialZoom: 11.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.lapor_tawuran',
                            ),
                            MarkerLayer(
                                markers: controller.zoneMarkers.toList()),
                            MarkerLayer(
                                markers: controller.iconMarkers.toList()),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Buat Laporan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.ADD_REPORT);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:
                      const Icon(Icons.add, size: 40, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}