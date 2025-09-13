// lib/app/controllers/auth_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lapor_tawuran/app/controllers/profile_controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<User?> user = Rx<User?>(null);

  final RxBool isAdmin = false.obs;
  final RxBool isCheckingAdmin = true.obs;

  var isLoading = false.obs;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    ever(user, _checkAdminRole);
    
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void _checkAdminRole(User? user) async {
    isCheckingAdmin.value = true;
    if (user != null) {
      try {
        IdTokenResult idTokenResult = await user.getIdTokenResult(true);
        if (idTokenResult.claims != null && idTokenResult.claims!['admin'] == true) {
          isAdmin.value = true;
        } else {
          isAdmin.value = false;
        }
      } catch (e) {
        isAdmin.value = false;
      } finally {
        isCheckingAdmin.value = false;
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().fetchUserProfile();
        }
      }
    } else {
      isAdmin.value = false;
      isCheckingAdmin.value = false;
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
  }

  Future<void> registerWithEmailAndPassword(String email, String password, String name, String phone) async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        await _firestore.collection('users').doc(uid).set({
          'name': name,
          'phone': phone,
          'email': email,
          'uid': uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'Password yang dimasukkan terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Akun sudah terdaftar untuk email ini.';
      } else {
        errorMessage = e.message ?? "Terjadi kesalahan registrasi.";
      }
      _showErrorSnackbar("Error Registrasi", errorMessage);
    } catch (e) {
      _showErrorSnackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        errorMessage = 'Email atau password yang Anda masukkan salah.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password yang dimasukkan salah.';
      } else {
        errorMessage = e.message ?? "Terjadi kesalahan login.";
      }
      _showErrorSnackbar("Error Login", errorMessage);
    } catch (e) {
      _showErrorSnackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser == true) {
        User user = userCredential.user!;
        await _firestore.collection('users').doc(user.uid).set({
          'name': user.displayName ?? '',
          'phone': user.phoneNumber ?? '',
          'email': user.email ?? '',
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      _showErrorSnackbar("Error Login Google", "Gagal melakukan login: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}