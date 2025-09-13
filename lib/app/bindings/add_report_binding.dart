import 'package:get/get.dart';
import 'package:lapor_tawuran/app/controllers/add_report_controller.dart';

class AddReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddReportController>(
      () => AddReportController(),
    );
  }
}