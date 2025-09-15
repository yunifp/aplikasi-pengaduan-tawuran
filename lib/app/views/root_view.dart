// lib/app/views/root_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lapor_tawuran/app/controllers/auth_controller.dart';
import 'package:lapor_tawuran/app/views/admin/admin_dashboard_view.dart';
import 'package:lapor_tawuran/app/views/login_view.dart';
import 'package:lapor_tawuran/app/views/main_scaffold_view.dart'; // Import baru

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
            return MainScaffoldView(); // Ganti ini
          }
        }
      } else {
        return LoginView();
      }
    });
  }
}