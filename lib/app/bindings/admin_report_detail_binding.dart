
import 'package:get/get.dart';
import 'package:lapor_tawuran/app/controllers/admin/admin_report_detail_controller.dart';

class AdminReportDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminReportDetailController>(
      () => AdminReportDetailController(),
    );
  }
}