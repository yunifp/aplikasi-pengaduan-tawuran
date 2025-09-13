// lib/app/bindings/history_binding.dart

import 'package:get/get.dart';
import 'package:lapor_tawuran/app/controllers/admin/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(
      () => HistoryController(),
    );
  }
}