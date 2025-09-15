import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lapor_tawuran/app/controllers/my_reports_controller.dart';

class MyReportsView extends GetView<MyReportsController> {
  const MyReportsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Saya"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.myReports.isEmpty) {
          return const Center(
            child: Text("Anda belum pernah membuat laporan."),
          );
        }
        return ListView.builder(
          itemCount: controller.myReports.length,
          itemBuilder: (context, index) {
            final report = controller.myReports[index];
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
                trailing: _buildStatusChip(report.status),
              ),
            );
          },
        );
      }),
    );
  }

  // Helper widget untuk menampilkan status dengan warna
  Widget _buildStatusChip(String status) {
    Color chipColor;
    String chipText;
    IconData chipIcon;

    switch (status) {
      case 'verified':
        chipColor = Colors.green;
        chipText = 'Disetujui';
        chipIcon = Icons.check_circle;
        break;
      case 'rejected':
        chipColor = Colors.red;
        chipText = 'Ditolak';
        chipIcon = Icons.cancel;
        break;
      default: // pending_verification
        chipColor = Colors.orange;
        chipText = 'Pending';
        chipIcon = Icons.pending;
        break;
    }

    return Chip(
      avatar: Icon(chipIcon, color: Colors.white, size: 16),
      label: Text(chipText),
      backgroundColor: chipColor,
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}