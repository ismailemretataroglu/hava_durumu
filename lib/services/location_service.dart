import 'package:geolocator/geolocator.dart';

import '../utils/app_exception.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    // KAPI 1: Konum servisi açık mı?
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw AppException(
        'Konum servisi kapalı. Ayarlardan konum servisini açmalısın.',
      );
    }

    // KAPI 2: İzin durumunu kontrol et
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw AppException('Konum izni verilmedi');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw AppException(
        'Konum izni kalıcı olarak reddedildi. Ayarlardan açmalısın.',
      );
    }

    // KAPI 3: Konumu al ve döndür
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
  }
}
