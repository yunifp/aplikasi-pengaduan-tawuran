// lib/app/views/splash_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lapor_tawuran/app/controllers/auth_controller.dart';
import 'package:lapor_tawuran/app/routes/app_pages.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  // Panggil AuthController
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  void _checkAuth() {
    Future.delayed(const Duration(seconds: 2), () {
      var authStatus = authController.user;

      if (authStatus != null) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}