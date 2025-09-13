// lib/app/views/add_report_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lapor_tawuran/app/controllers/add_report_controller.dart';

class AddReportView extends GetView<AddReportController> {
  const AddReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Laporan Baru'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Deskripsi Singkat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Jelaskan kejadian yang Anda lihat...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bukti Foto (Opsional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.selectedImage.value == null) {
                return OutlinedButton.icon(
                  onPressed: () => controller.showImageSourceDialog(),
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Pilih dari Galeri/Kamera'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Image.file(
                      controller.selectedImage.value!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    TextButton(
                      // --- INI BAGIAN YANG DIPERBAIKI ---
                      onPressed: () => controller.showImageSourceDialog(),
                      child: const Text('Ganti Gambar'),
                    )
                  ],
                );
              }
            }),
            const SizedBox(height: 40),
            Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () => controller.submitReport(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('KIRIM LAPORAN'),
                  )),
          ],
        ),
      ),
    );
  }
}