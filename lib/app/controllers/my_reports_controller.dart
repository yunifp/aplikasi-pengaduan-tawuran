import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lapor_tawuran/app/models/report_model.dart';

class MyReportsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<Report> myReports = RxList<Report>();
  var isLoading = true.obs;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    listenToMyReports();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void listenToMyReports() {
    User? user = _auth.currentUser;
    if (user == null) {
      isLoading.value = false;
      Get.snackbar("Error", "Anda harus login untuk melihat laporan Anda.");
      return;
    }

    isLoading.value = true;
    final query = _firestore
        .collection('reports')
        .where('uid', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true);

    _subscription = query.snapshots().listen((snapshot) {
      final reports = snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList();
      myReports.assignAll(reports);
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      Get.snackbar("Error", "Gagal mengambil data laporan Anda: $error");
    });
  }
}