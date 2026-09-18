import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/journey.dart';

enum GpsSignalState {
  searching,
  locked,
  lost,
  permissionDenied,
  serviceDisabled,
}

class LocationService extends ChangeNotifier {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  LocationPoint? _currentLocation;
  bool _isRealGps = false;
  bool _hasPermission = false;
  bool _isEmergencyMode = false;
  GpsSignalState _signalState = GpsSignalState.searching;
  String _statusMessage = 'GPS Initializing';
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
        altitude: 8.5,
      );

  bool get isRealGps => _isRealGps;
  bool get hasPermission => _hasPermission;
  bool get isEmergencyMode => _isEmergencyMode;
  GpsSignalState get signalState => _signalState;
  String get statusMessage => _statusMessage;

  Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _hasPermission = false;
      _signalState = GpsSignalState.serviceDisabled;
      _statusMessage = 'Location services disabled in system settings.';
      notifyListeners();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _hasPermission = false;
        _signalState = GpsSignalState.permissionDenied;
        _statusMessage = 'Location permission denied by user.';
        notifyListeners();
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _hasPermission = false;
      _signalState = GpsSignalState.permissionDenied;
      _statusMessage = 'Location permission permanently blocked.';
      notifyListeners();
      return false;
    }

    _hasPermission = true;
    notifyListeners();
    return true;
  }

  /// Starts adaptive location tracking:
  /// - Normal Transit: battery-efficient (10m filter, high accuracy)
  /// - Emergency Mode: high frequency (2m filter, best accuracy)
  Future<void> startTracking({bool isEmergency = false}) async {
    _isEmergencyMode = isEmergency;
    final permitted = await checkAndRequestPermission();
    if (!permitted) {
      _isRealGps = false;
      notifyListeners();
      return;
    }

    _signalState = GpsSignalState.searching;
    _statusMessage = 'Acquiring high-accuracy GPS fix...';
    notifyListeners();

    try {
      final initialPos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 6),
        ),
      );
      _updateFromPosition(initialPos);
      _isRealGps = true;
      _signalState = GpsSignalState.locked;
      _statusMessage = 'REAL DEVICE LOCATION';
    } catch (_) {
      // If immediate fix timed out, continue with stream
      _statusMessage = 'Acquiring satellite lock...';
    }

    await _startPositionStream(isEmergency);
  }

  Future<void> _startPositionStream(bool isEmergency) async {
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
        _signalState = GpsSignalState.locked;
        _statusMessage = 'REAL DEVICE LOCATION (±${pos.accuracy.toStringAsFixed(1)}m)';
        notifyListeners();
      },
      onError: (err) {
        _signalState = GpsSignalState.lost;
        _statusMessage = 'GPS signal lost. Maintaining last known coordinates.';
        notifyListeners();
      },
    );
  }

  /// Adaptively switch between power-saving transit mode and high-frequency emergency mode
  void setEmergencyMode(bool isEmergency) {
    if (_isEmergencyMode != isEmergency) {
      _isEmergencyMode = isEmergency;
      if (_positionSubscription != null) {
        _startPositionStream(isEmergency);
      }
    }
  }

  void _updateFromPosition(Position pos) {
    _currentLocation = LocationPoint(
      latitude: pos.latitude,
      longitude: pos.longitude,
      accuracy: pos.accuracy,
      landmark: '${pos.latitude.toStringAsFixed(4)}°N, ${pos.longitude.toStringAsFixed(4)}°E',
      speedKmh: (pos.speed * 3.6).clamp(0.0, 180.0),
      heading: pos.heading,
      altitude: pos.altitude,
      timestamp: pos.timestamp,
    );
    notifyListeners();
  }

  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _signalState = GpsSignalState.searching;
    _statusMessage = 'GPS Standby';
    notifyListeners();
  }
}
