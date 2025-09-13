// lib/app/views/admin/history_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lapor_tawuran/app/controllers/admin/history_controller.dart';
import 'package:lapor_tawuran/app/routes/app_pages.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Laporan')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.processedReports.isEmpty) {
          return const Center(
            child: Text("Belum ada riwayat laporan yang diproses."),
          );
        }
        return ListView.builder(
          itemCount: controller.processedReports.length,
          itemBuilder: (context, index) {
            final report = controller.processedReports[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  report.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  DateFormat(
                    'dd MMM yyyy, HH:mm',
                    'id_ID',
                  ).format(report.timestamp.toDate()),
                ),
                trailing: Icon(
                  report.status == 'verified'
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: report.status == 'verified'
                      ? Colors.green
                      : Colors.red,
                ),
                onTap: () {
                  Get.toNamed(Routes.ADMIN_REPORT_DETAIL, arguments: report);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
