import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lapor_tawuran/app/models/report_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Report> reports = RxList<Report>();
  final RxList<Marker> markers = RxList<Marker>();
  final Rx<Duration?> selectedFilter = Rx<Duration?>(null);
  var isLoading = true.obs;
  var tabIndex = 0.obs;
  StreamSubscription? _reportSubscription;
  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    listenToReports();
  }

  @override
  void onClose() {
    _reportSubscription?.cancel();
    super.onClose();
  }

  Future<void> refreshData() async {
    _reportSubscription?.cancel();
    listenToReports();
  }

  void listenToReports() {
    isLoading.value = true;
    _reportSubscription?.cancel();

    Query query = _firestore
        .collection('reports')
        .where('status', isEqualTo: 'verified');

    if (selectedFilter.value != null) {
      DateTime startTime = DateTime.now().subtract(selectedFilter.value!);
      query = query.where('timestamp', isGreaterThanOrEqualTo: startTime);
    }

    query = query.orderBy('timestamp', descending: true);

    _reportSubscription = query.snapshots().listen(
      (QuerySnapshot reportSnapshot) {
        final fetchedReports = reportSnapshot.docs
            .map((doc) => Report.fromFirestore(doc))
            .toList();

        reports.assignAll(fetchedReports);

        _buildMarkers();

        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        Get.snackbar("Error", "Gagal mengambil data laporan: $error");
      },
    );
  }

  void applyFilter(Duration? duration) {
    selectedFilter.value = duration;
    listenToReports(); 
    Get.back(); 
  }

  void showFilterDialog() {
    Get.dialog(
      SimpleDialog(
        title: const Text('Filter Laporan'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () => applyFilter(null),
            child: const Text('Semua Waktu'),
          ),
          SimpleDialogOption(
            onPressed: () => applyFilter(const Duration(hours: 1)),
            child: const Text('1 Jam Terakhir'),
          ),
          SimpleDialogOption(
            onPressed: () => applyFilter(const Duration(hours: 3)),
            child: const Text('3 Jam Terakhir'),
          ),
          SimpleDialogOption(
            onPressed: () => applyFilter(const Duration(days: 1)),
            child: const Text('24 Jam Terakhir'),
          ),
        ],
      ),
    );
  }

  void _buildMarkers() {
    final newMarkers = reports.map((report) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(report.location.latitude, report.location.longitude),
        child: GestureDetector(
          onTap: () => showReportDetails(report),
          child: const Icon(Icons.location_on, color: Colors.red, size: 40.0),
        ),
      );
    }).toList();
    markers.assignAll(newMarkers);
  }

  void showReportDetails(Report tappedReport) {
    final reportsAtSameLocation = reports.where((report) {
      return report.location.latitude == tappedReport.location.latitude &&
          report.location.longitude == tappedReport.location.longitude;
    }).toList();

    Get.bottomSheet(
      Container(
        height: Get.height * 0.6,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Laporan di Lokasi Ini (${reportsAtSameLocation.length} Laporan)",
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: reportsAtSameLocation.length,
                itemBuilder: (context, index) {
                  final report = reportsAtSameLocation[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat(
                              'EEEE, dd MMMM yyyy, HH:mm',
                              'id_ID',
                            ).format(report.timestamp.toDate()),
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(report.description),
                          const SizedBox(height: 12),
                          if (report.imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                report.imageUrl!,
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        heightFactor: 3,
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }
}
