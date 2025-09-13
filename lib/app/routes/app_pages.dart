import 'package:get/get.dart';
import 'package:lapor_tawuran/app/bindings/add_report_binding.dart';
import 'package:lapor_tawuran/app/bindings/admin_dashboard_binding.dart';
import 'package:lapor_tawuran/app/bindings/admin_report_detail_binding.dart';
import 'package:lapor_tawuran/app/bindings/home_binding.dart';
import 'package:lapor_tawuran/app/views/add_report_view.dart';
import 'package:lapor_tawuran/app/views/admin/admin_dashboard_view.dart';
import 'package:lapor_tawuran/app/views/admin/admin_report_detail_view.dart';
import 'package:lapor_tawuran/app/views/home_view.dart';
import 'package:lapor_tawuran/app/views/login_view.dart';
import 'package:lapor_tawuran/app/views/register_view.dart';
import 'package:lapor_tawuran/app/views/root_view.dart';
import 'package:lapor_tawuran/app/bindings/profile_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.ROOT;

  static final routes = [
    GetPage(
      name: Routes.ROOT,
      page: () => const RootView(),
      bindings: [
        HomeBinding(),
        AdminDashboardBinding(),
        ProfileBinding(),
      ],
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      bindings: [HomeBinding(), ProfileBinding()],
    ),
    GetPage(name: Routes.LOGIN, page: () => LoginView()),
    GetPage(name: Routes.REGISTER, page: () => RegisterView()),
    GetPage(
      name: Routes.ADD_REPORT,
      page: () => const AddReportView(),
      binding: AddReportBinding(),
    ),
   GetPage(
      name: Routes.ADMIN_DASHBOARD,
      page: () => AdminDashboardView(),
      bindings: [
        AdminDashboardBinding(),
        ProfileBinding(), // Daftarkan ProfileBinding di sini juga
      ],
    ),
    GetPage(
      name: Routes.ADMIN_REPORT_DETAIL,
      page: () => AdminReportDetailView(),
      binding: AdminReportDetailBinding(),
    ),
  ];
}
