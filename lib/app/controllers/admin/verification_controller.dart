import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lapor_tawuran/app/models/report_model.dart';

class VerificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Report> pendingReports = RxList<Report>();
  var isLoading = true.obs;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    listenToPendingReports();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void listenToPendingReports() {
    isLoading.value = true;
    final query = _firestore
        .collection('reports')
        .where('status', isEqualTo: 'pending_verification')
        .orderBy('timestamp', descending: true);

    _subscription = query.snapshots().listen((snapshot) {
      final reports = snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList();
      pendingReports.assignAll(reports);
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      Get.snackbar("Error", "Gagal mengambil data laporan: $error");
    });
  }
}