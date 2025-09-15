import 'package:get/get.dart';
import 'package:lapor_tawuran/app/controllers/my_reports_controller.dart';

class MyReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyReportsController>(() => MyReportsController());
  }
}