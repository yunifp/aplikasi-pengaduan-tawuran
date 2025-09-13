import 'package:get/get.dart';
import 'package:lapor_tawuran/app/controllers/admin/admin_dashboard_controller.dart';
import 'package:lapor_tawuran/app/controllers/admin/history_controller.dart';
import 'package:lapor_tawuran/app/controllers/admin/verification_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDashboardController>(() => AdminDashboardController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<VerificationController>(() => VerificationController());
  }
}
