import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/journey.dart';

class LocationService extends ChangeNotifier {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  LocationPoint? _currentLocation;
  bool _isRealGps = false;
  bool _hasPermission = false;
  StreamSubscription<Position>? _positionSubscription;

  LocationPoint get currentLocation =>
      _currentLocation ??
      LocationPoint(
        latitude: 9.9674,
        longitude: 76.2848,
        accuracy: 4.2,
        landmark: 'MG Road Metro Station, Kochi',
        speedKmh: 0.0,
        heading: 0.0,
      );

  bool get isRealGps => _isRealGps;
  bool get hasPermission => _hasPermission;

  Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _hasPermission = false;
      notifyListeners();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _hasPermission = false;
        notifyListeners();
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _hasPermission = false;
      notifyListeners();
      return false;
    }

    _hasPermission = true;
    notifyListeners();
    return true;
  }

  Future<void> startTracking({bool isEmergency = false}) async {
    final permitted = await checkAndRequestPermission();
    if (!permitted) {
      // Use Kochi default with simulated badge
      _isRealGps = false;
      notifyListeners();
      return;
    }

    try {
      final initialPos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      _updateFromPosition(initialPos);
      _isRealGps = true;
    } catch (_) {
      _isRealGps = false;
    }

    await _positionSubscription?.cancel();
    final settings = LocationSettings(
      accuracy: isEmergency ? LocationAccuracy.best : LocationAccuracy.high,
      distanceFilter: isEmergency ? 2 : 10,
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen(
      (pos) {
        _updateFromPosition(pos);
        _isRealGps = true;
        notifyListeners();
      },
      onError: (_) {
        _isRealGps = false;
        notifyListeners();
      },
    );
  }

  void _updateFromPosition(Position pos) {
    _currentLocation = LocationPoint(
      latitude: pos.latitude,
      longitude: pos.longitude,
      accuracy: pos.accuracy,
      landmark: '${pos.latitude.toStringAsFixed(4)}°N, ${pos.longitude.toStringAsFixed(4)}°E',
      speedKmh: (pos.speed * 3.6).clamp(0.0, 180.0),
      heading: pos.heading,
      timestamp: pos.timestamp,
    );
    notifyListeners();
  }

  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }
}
