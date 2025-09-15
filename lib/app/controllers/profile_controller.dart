import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:lapor_tawuran/app/controllers/auth_controller.dart';
import 'package:lapor_tawuran/app/models/user_model.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<UserModel?> userProfile = Rx<UserModel?>(null);
  var isLoading = false.obs;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  final cloudinary =
      CloudinaryPublic('duzednwqo', 'lapor_tawuran_unsigned', cache: false);

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    fetchUserProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    User? user = _auth.currentUser;
    if (user == null) {
      isLoading.value = false;
      return;
    }

    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        userProfile.value = UserModel.fromFirestore(doc);
      } else {
        final defaultProfile = {
          'uid': user.uid,
          'email': user.email ?? 'Tidak ada email',
          'name': user.displayName ?? 'Pengguna Baru',
          'phone': user.phoneNumber ?? 'Tidak ada nomor HP',
          'createdAt': FieldValue.serverTimestamp(),
          'photoUrl': user.photoURL,
        };
        await _firestore.collection('users').doc(user.uid).set(defaultProfile);
        DocumentSnapshot newDoc =
            await _firestore.collection('users').doc(user.uid).get();
        userProfile.value = UserModel.fromFirestore(newDoc);
      }

      nameController.text = userProfile.value!.name;
      phoneController.text = userProfile.value!.phone;
      emailController.text = userProfile.value!.email;
    } catch (e) {
      userProfile.value = null;
      Get.snackbar("Error", "Gagal memuat data profil: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    isLoading.value = true;
    User? user = _auth.currentUser;
    if (user == null) {
      isLoading.value = false;
      return;
    }

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'name': nameController.text,
        'phone': phoneController.text,
      });
      await fetchUserProfile();
      Get.snackbar("Sukses", "Profil berhasil diperbarui.");
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui profil.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    isLoading.value = true;
    User? user = _auth.currentUser;
    if (user == null) {
      isLoading.value = false;
      return;
    }

    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path,
            resourceType: CloudinaryResourceType.Image),
      );
      String imageUrl = response.secureUrl;
      await _firestore.collection('users').doc(user.uid).update({
        'photoUrl': imageUrl,
      });
      await fetchUserProfile();
      Get.snackbar("Sukses", "Foto profil berhasil diperbarui.");
    } catch (e) {
      Get.snackbar("Error", "Gagal mengunggah foto profil.");
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    Get.find<AuthController>().signOut();
  }
}