// lib/app/controllers/admin/admin_report_detail_controller.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lapor_tawuran/app/models/report_model.dart';

class AdminReportDetailController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Report report;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil objek Report yang dikirim dari halaman sebelumnya
    report = Get.arguments as Report;
  }

  Future<void> approveReport() async {
    await _updateReportStatus('verified');
  }

  Future<void> rejectReport() async {
    await _updateReportStatus('rejected');
  }

  Future<void> _updateReportStatus(String newStatus) async {
    isLoading.value = true;
    try {
      await _firestore.collection('reports').doc(report.id).update({
        'status': newStatus,
      });
      Get.back(); // Kembali ke halaman daftar
      Get.snackbar(
        "Sukses",
        "Status laporan berhasil diperbarui menjadi '$newStatus'",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui status laporan: $e");
    } finally {
      isLoading.value = false;
    }
  }
}