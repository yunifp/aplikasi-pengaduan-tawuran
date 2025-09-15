// lib/app/views/register_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lapor_tawuran/app/controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();

  RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Akun Baru'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey.shade800,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Buat Akun', style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Bergabunglah dengan komunitas peduli keamanan.', style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
                const SizedBox(height: 40),
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap', prefixIcon: Icon(Icons.person_outline)),
                  validator: (value) => (value == null || value.isEmpty) ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.phoneController,
                  decoration: const InputDecoration(labelText: 'Nomor HP', prefixIcon: Icon(Icons.phone_outlined)),
                  keyboardType: TextInputType.phone,
                  validator: (value) => (value == null || value.isEmpty) ? 'Nomor HP tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
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
                  validator: (value) => (value == null || value.length < 6) ? 'Password minimal 6 karakter' : null,
                ),
                const SizedBox(height: 24),
                Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.registerWithEmailAndPassword(
                              controller.emailController.text,
                              controller.passwordController.text,
                              controller.nameController.text,
                              controller.phoneController.text,
                            );
                          }
                        },
                        child: const Text('DAFTAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      )),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun?"),
                    TextButton(onPressed: () => Get.back(), child: const Text('Login')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}