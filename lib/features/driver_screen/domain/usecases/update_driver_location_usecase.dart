import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

/// UseCase لتحديث موقع السائق في Firebase
class UpdateDriverLocationUseCase {
  final FirebaseFirestore firestore;

  UpdateDriverLocationUseCase({required this.firestore});

  /// استدعاء الـ UseCase لتحديث موقع السائق
  Future<void> call({
    required String driverId,
    required double latitude,
    required double longitude,
  }) async {
    await firestore.collection('drivers').doc(driverId).update({
      'lat': GeoPoint(latitude, longitude),
      'lastloacationUpdate': FieldValue.serverTimestamp(),
      'isOnline': true,
    });
  }

  /// الحصول على الموقع الحالي للسائق
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }
}
