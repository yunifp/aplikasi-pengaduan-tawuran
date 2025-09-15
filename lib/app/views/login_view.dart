// lib/app/views/login_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lapor_tawuran/app/controllers/auth_controller.dart';
import 'package:lapor_tawuran/app/routes/app_pages.dart';

class LoginView extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.security, size: 80, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 24),
                  Text(
                    'Selamat Datang Kembali',
                    textAlign: TextAlign.center,
                    style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login untuk melaporkan insiden di sekitar Anda.',
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => (value == null || !GetUtils.isEmail(value)) ? 'Masukkan email yang valid' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.passwordController,
                    decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
                    obscureText: true,
                    validator: (value) => (value == null || value.isEmpty) ? 'Password tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 24),
                  Obx(() => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.loginWithEmailAndPassword(
                                controller.emailController.text,
                                controller.passwordController.text,
                              );
                            }
                          },
                          child: const Text('LOGIN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        )),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('ATAU', style: TextStyle(color: Colors.grey.shade600)),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () => controller.signInWithGoogle(),
                    icon: Image.asset('assets/google_logo.png', height: 20.0),
                    label: const Text('Login dengan Google'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Belum punya akun?"),
                      TextButton(
                        onPressed: () {
                          controller.emailController.clear();
                          controller.passwordController.clear();
                          Get.toNamed(Routes.REGISTER);
                        },
                        child: const Text('Daftar di sini'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}