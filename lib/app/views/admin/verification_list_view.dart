// lib/app/views/admin/verification_list_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lapor_tawuran/app/controllers/admin/verification_controller.dart';
import 'package:lapor_tawuran/app/routes/app_pages.dart';

class VerificationListView extends GetView<VerificationController> {
  const VerificationListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.pendingReports.isEmpty) {
        return const Center(child: Text("Tidak ada laporan yang perlu diverifikasi."));
      }
      return ListView.builder(
        itemCount: controller.pendingReports.length,
        itemBuilder: (context, index) {
          final report = controller.pendingReports[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                report.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(report.timestamp.toDate()),
              ),
              onTap: () {
               Get.toNamed(
                  Routes.ADMIN_REPORT_DETAIL,
                  arguments: report, // Kirim seluruh objek report ke halaman detail
                );
              },
            ),
          );
        },
      );
    });
  }
}