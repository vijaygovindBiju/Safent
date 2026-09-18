import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService extends ChangeNotifier {
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  StreamSubscription<UserAccelerometerEvent>? _accelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;

  double _currentAccelG = 1.0;
  double _peakAccelG = 1.0;
  double _currentGyroDps = 0.0;
  double _soundDb = 45.0;
  bool _isRealHardware = false;

  bool _impactCandidate = false;
  bool _rotationCandidate = false;
  bool _acousticCandidate = false;

  String? _lastAnomaly;
  DateTime? _lastAnomalyTime;

  double get currentAccelG => _currentAccelG;
  double get peakAccelG => _peakAccelG;
  double get currentGyroDps => _currentGyroDps;
  double get soundDb => _soundDb;
  bool get isRealHardware => _isRealHardware;
  String? get lastAnomaly => _lastAnomaly;
  DateTime? get lastAnomalyTime => _lastAnomalyTime;

  bool get impactCandidate => _impactCandidate;
  bool get rotationCandidate => _rotationCandidate;
  bool get acousticCandidate => _acousticCandidate;

  void startListening() {
    try {
      // 3-axis Accelerometer
      _accelSub = userAccelerometerEventStream().listen(
        (event) {
          // userAccelerometer provides acceleration without gravity
          // Vector magnitude: sqrt(x² + y² + z²) / 9.8 + 1.0 (to include nominal 1G baseline)
          final linearMag = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
          final gForce = 1.0 + (linearMag / 9.80665);
          _currentAccelG = double.parse(gForce.toStringAsFixed(2));
          if (_currentAccelG > _peakAccelG) {
            _peakAccelG = _currentAccelG;
          }

          // Crash / severe impact candidate threshold (> 3.8G)
          if (_currentAccelG >= 3.8) {
            _impactCandidate = true;
            _lastAnomaly = 'High-G Impact (${_currentAccelG}G)';
            _lastAnomalyTime = DateTime.now();
          } else {
            _impactCandidate = false;
          }

          _isRealHardware = true;
          notifyListeners();
        },
        onError: (_) {
          _isRealHardware = false;
        },
      );

      // 3-axis Gyroscope (rad/s to deg/s)
      _gyroSub = gyroscopeEventStream().listen(
        (event) {
          final radMag = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
          _currentGyroDps = double.parse((radMag * 57.2958).toStringAsFixed(1));

          // Sudden vehicle rollover / spin (> 80 deg/s)
          if (_currentGyroDps >= 80.0) {
            _rotationCandidate = true;
            _lastAnomaly = 'Severe Tumble ($_currentGyroDps°/s)';
            _lastAnomalyTime = DateTime.now();
          } else {
            _rotationCandidate = false;
          }

          _isRealHardware = true;
          notifyListeners();
        },
        onError: (_) {
          _isRealHardware = false;
        },
      );
    } catch (_) {
      _isRealHardware = false;
    }
  }

  // Trigger simulated hardware spike for demonstration
  void triggerSimulatedAnomaly() {
    _currentAccelG = 4.85;
    _peakAccelG = 4.85;
    _currentGyroDps = 86.4;
    _soundDb = 92.0;
    _impactCandidate = true;
    _rotationCandidate = true;
    _acousticCandidate = true;
    _lastAnomaly = 'Severe Multi-Axis Collision & Acoustic Spike';
    _lastAnomalyTime = DateTime.now();
    notifyListeners();
  }

  void resetPeak() {
    _peakAccelG = 1.0;
    _impactCandidate = false;
    _rotationCandidate = false;
    _acousticCandidate = false;
    notifyListeners();
  }

  void stopListening() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    _accelSub = null;
    _gyroSub = null;
  }
}
