// lib/app/controllers/admin/history_controller.dart

import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lapor_tawuran/app/models/report_model.dart';

class HistoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Report> processedReports = RxList<Report>();
  var isLoading = true.obs;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    listenToProcessedReports();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void listenToProcessedReports() {
    isLoading.value = true;
    final query = _firestore
        .collection('reports')
        .where('status', whereIn: ['verified', 'rejected'])
        .orderBy('timestamp', descending: true);

    _subscription = query.snapshots().listen((snapshot) {
      final reports = snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList();
      processedReports.assignAll(reports);
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      Get.snackbar("Error", "Gagal mengambil data riwayat: $error");
    });
  }
}