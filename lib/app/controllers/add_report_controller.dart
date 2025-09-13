// lib/app/controllers/add_report_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class AddReportController extends GetxController {
  late TextEditingController descriptionController;
  var isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final cloudinary = CloudinaryPublic(
    'duzednwqo',
    'lapor_tawuran_unsigned',
    cache: false,
  );

  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<Position?> currentPosition = Rx<Position?>(null);

  @override
  void onInit() {
    super.onInit();
    descriptionController = TextEditingController();
    getCurrentLocation();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
  
  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Izin Lokasi", "Izin lokasi ditolak.");
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar("Izin Lokasi", "Izin lokasi ditolak secara permanen, silahkan aktifkan di pengaturan.");
        return;
      } 
      
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      currentPosition.value = position;
    } catch (e) {
      Get.snackbar("Error", "Gagal mendapatkan lokasi: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
  
  void pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memilih gambar: ${e.toString()}");
    }
  }

  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Kamera'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void submitReport() async {
    if (descriptionController.text.isEmpty) {
      Get.snackbar("Error", "Deskripsi tidak boleh kosong.");
      return;
    }
    if (currentPosition.value == null) {
      Get.snackbar("Error", "Lokasi tidak ditemukan. Pastikan GPS Anda aktif.");
      return;
    }
    
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar("Error", "Anda harus login untuk membuat laporan.");
      return;
    }

    isLoading.value = true;
    try {
      String? imageUrl;

      if (selectedImage.value != null) {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(selectedImage.value!.path,
              resourceType: CloudinaryResourceType.Image),
        );
        imageUrl = response.secureUrl;
      }

      await _firestore.collection('reports').add({
        'uid': user.uid,
        'description': descriptionController.text,
        'location': GeoPoint(currentPosition.value!.latitude, currentPosition.value!.longitude),
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending_verification',
      });

      Get.back();
      Get.snackbar("Sukses", "Laporan Anda berhasil dikirim dan sedang menunggu verifikasi.");

    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan saat mengirim laporan: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}