import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxString currentAddress = "Memuat lokasi...".obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          currentAddress.value = "Izin lokasi ditolak";
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        currentAddress.value = "Izin lokasi ditolak permanen";
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = position;
      await _getAddressFromLatLng(position);
    } catch (e) {
      Get.snackbar("Error", "Gagal mendapatkan lokasi: ${e.toString()}");
      currentAddress.value = "Gagal mendapatkan lokasi";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      currentAddress.value = "${place.street}, ${place.subLocality}";
    } catch (e) {
      currentAddress.value = "Gagal mendapatkan alamat";
    }
  }
}