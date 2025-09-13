// lib/app/views/admin/admin_dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lapor_tawuran/app/controllers/admin/admin_dashboard_controller.dart';
import 'package:lapor_tawuran/app/views/admin/history_view.dart';
import 'package:lapor_tawuran/app/views/admin/verification_list_view.dart';
import 'package:lapor_tawuran/app/views/profile_view.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  AdminDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = [
      const VerificationListView(),
      const HistoryView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: Obx(() => pages[controller.tabIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTabIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.pending_actions), label: 'Verifikasi'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}