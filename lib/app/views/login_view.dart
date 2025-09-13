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
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Selamat Datang', style: Get.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Login untuk melanjutkan', style: Get.textTheme.titleMedium),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => (value == null || !value.isEmail) ? 'Masukkan email yang valid' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.passwordController,
                    decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                    obscureText: true,
                    validator: (value) => (value == null || value.isEmpty) ? 'Password tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 30),
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
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                          child: const Text('Login'),
                        )),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 16),
                  Row(children: const [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('ATAU')), Expanded(child: Divider())]),
                  const SizedBox(height: 16),
                 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}