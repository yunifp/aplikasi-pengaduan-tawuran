
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lapor_tawuran/app/controllers/auth_controller.dart';
import 'package:lapor_tawuran/app/views/admin/admin_dashboard_view.dart';
import 'package:lapor_tawuran/app/views/home_view.dart';
import 'package:lapor_tawuran/app/views/login_view.dart';

class RootView extends GetView<AuthController> {
  const RootView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.user.value != null) {
        if (controller.isCheckingAdmin.value) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          if (controller.isAdmin.value) {
            return AdminDashboardView();
          } else {
            return HomeView();
          }
        }
      } else {
        return LoginView();
      }
    });
  }
}