// lib/app/views/admin/admin_report_detail_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lapor_tawuran/app/controllers/admin/admin_report_detail_controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AdminReportDetailView extends GetView<AdminReportDetailController> {
  const AdminReportDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Laporan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Deskripsi Laporan", style: Get.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(controller.report.description),
            const Divider(height: 32),

            Text("Waktu Kejadian", style: Get.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              DateFormat(
                'EEEE, dd MMMM yyyy, HH:mm',
                'id_ID',
              ).format(controller.report.timestamp.toDate()),
            ),
            const Divider(height: 32),

            Text("Foto Bukti", style: Get.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (controller.report.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(controller.report.imageUrl!),
              )
            else
              const Text("Tidak ada bukti foto."),
            const Divider(height: 32),

            Text("Lokasi Kejadian", style: Get.textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                    controller.report.location.latitude,
                    controller.report.location.longitude,
                  ),
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.lapor_tawuran',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          controller.report.location.latitude,
                          controller.report.location.longitude,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: controller.report.status == 'pending_verification'
          ? Padding(
              // Jika status 'pending', tampilkan tombol
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller.rejectReport(),
                              icon: const Icon(Icons.close),
                              label: const Text("Tolak"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller.approveReport(),
                              icon: const Icon(Icons.check),
                              label: const Text("Setujui"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            )
          : null,
    );
  }
}
