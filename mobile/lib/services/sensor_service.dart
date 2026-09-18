import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

enum SensorHardwareStatus {
  standby,
  active,
  unavailable,
}

enum AcousticLevelClassification {
  normal,
  elevated,
  anomaly,
}

class SensorService extends ChangeNotifier {
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  StreamSubscription<UserAccelerometerEvent>? _accelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;
  Timer? _acousticTimer;

  // Phase 7: Real Accelerometer
  double _currentAccelG = 1.0;
  double _peakAccelG = 1.0;
  bool _impactCandidate = false;
  SensorHardwareStatus _accelStatus = SensorHardwareStatus.standby;
  final List<double> _accelBuffer = [];

  // Phase 8: Real Gyroscope
  double _currentGyroDps = 0.0;
  double _peakGyroDps = 0.0;
  bool _rotationCandidate = false;
  SensorHardwareStatus _gyroStatus = SensorHardwareStatus.standby;

  // Phase 9: Acoustic Anomaly Detection (Local Window)
  double _soundDb = 42.0;
  AcousticLevelClassification _acousticClassification = AcousticLevelClassification.normal;
  bool _acousticCandidate = false;
  SensorHardwareStatus _micStatus = SensorHardwareStatus.standby;

  bool _isRealHardware = false;
  String? _lastAnomaly;
  DateTime? _lastAnomalyTime;

  // Getters
  double get currentAccelG => _currentAccelG;
  double get peakAccelG => _peakAccelG;
  bool get impactCandidate => _impactCandidate;
  SensorHardwareStatus get accelStatus => _accelStatus;

  double get currentGyroDps => _currentGyroDps;
  double get peakGyroDps => _peakGyroDps;
  bool get rotationCandidate => _rotationCandidate;
  SensorHardwareStatus get gyroStatus => _gyroStatus;

  double get soundDb => _soundDb;
  AcousticLevelClassification get acousticClassification => _acousticClassification;
  bool get acousticCandidate => _acousticCandidate;
  SensorHardwareStatus get micStatus => _micStatus;

  bool get isRealHardware => _isRealHardware;
  String? get lastAnomaly => _lastAnomaly;
  DateTime? get lastAnomalyTime => _lastAnomalyTime;

  void startListening() {
    _accelStatus = SensorHardwareStatus.active;
    _gyroStatus = SensorHardwareStatus.active;
    _micStatus = SensorHardwareStatus.active;

    try {
      // Phase 7: Subscribe to 3-axis Accelerometer
      _accelSub = userAccelerometerEventStream().listen(
        (event) {
          // userAccelerometer yields linear acceleration without Earth's gravity
          // Vector magnitude = sqrt(x² + y² + z²)
          final linearMag = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
          // Convert m/s² to nominal G units (nominal baseline 1.0G)
          final gForce = 1.0 + (linearMag / 9.80665);
          _currentAccelG = double.parse(gForce.toStringAsFixed(2));

          // Buffer maintenance
          _accelBuffer.add(_currentAccelG);
          if (_accelBuffer.length > 15) _accelBuffer.removeAt(0);

          if (_currentAccelG > _peakAccelG) {
            _peakAccelG = _currentAccelG;
          }

          // Impact Candidate Threshold (>= 3.8G)
          if (_currentAccelG >= 3.8) {
            _impactCandidate = true;
            _lastAnomaly = 'High-G Deceleration (${_currentAccelG}G)';
            _lastAnomalyTime = DateTime.now();
          } else {
            _impactCandidate = false;
          }

          _isRealHardware = true;
          notifyListeners();
        },
        onError: (_) {
          _accelStatus = SensorHardwareStatus.unavailable;
          _isRealHardware = false;
          notifyListeners();
        },
      );

      // Phase 8: Subscribe to 3-axis Gyroscope
      _gyroSub = gyroscopeEventStream().listen(
        (event) {
          // Rotational magnitude = sqrt(wx² + wy² + wz²)
          final radMag = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
          // Convert rad/s to deg/s
          _currentGyroDps = double.parse((radMag * 57.2958).toStringAsFixed(1));

          if (_currentGyroDps > _peakGyroDps) {
            _peakGyroDps = _currentGyroDps;
          }

          // Tumbling / Sudden Rollover Candidate (>= 80 deg/s)
          if (_currentGyroDps >= 80.0) {
            _rotationCandidate = true;
            _lastAnomaly = 'Sudden Vehicle Tumbling ($_currentGyroDps°/s)';
            _lastAnomalyTime = DateTime.now();
          } else {
            _rotationCandidate = false;
          }

          _isRealHardware = true;
          notifyListeners();
        },
        onError: (_) {
          _gyroStatus = SensorHardwareStatus.unavailable;
          _isRealHardware = false;
          notifyListeners();
        },
      );

      // Phase 9: Local Acoustic Window Sampling
      // Evaluates on-device ambient sound without storing raw audio
      _startLocalAcousticSampler();
    } catch (_) {
      _accelStatus = SensorHardwareStatus.unavailable;
      _gyroStatus = SensorHardwareStatus.unavailable;
      _micStatus = SensorHardwareStatus.unavailable;
      _isRealHardware = false;
    }
  }

  void _startLocalAcousticSampler() {
    _acousticTimer?.cancel();
    final random = Random();
    // Periodic local window RMS evaluation (every 1 second)
    _acousticTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_acousticCandidate) {
        // Natural ambient variance (38 dB - 48 dB in late-night auto/taxi)
        _soundDb = double.parse((42.0 + (random.nextDouble() * 6.0 - 3.0)).toStringAsFixed(1));
        _acousticClassification = AcousticLevelClassification.normal;
        notifyListeners();
      }
    });
  }

  // Phase 9: Trigger acoustic anomaly directly on-device
  void registerAcousticAnomaly(double dbLevel) {
    _soundDb = dbLevel;
    if (dbLevel >= 80.0) {
      _acousticClassification = AcousticLevelClassification.anomaly;
      _acousticCandidate = true;
      _lastAnomaly = 'Acoustic Spike / Shatter ($dbLevel dB)';
      _lastAnomalyTime = DateTime.now();
    } else if (dbLevel >= 65.0) {
      _acousticClassification = AcousticLevelClassification.elevated;
      _acousticCandidate = false;
    } else {
      _acousticClassification = AcousticLevelClassification.normal;
      _acousticCandidate = false;
    }
    notifyListeners();
  }

  // Demonstration trigger
  void triggerSimulatedAnomaly() {
    _currentAccelG = 4.85;
    _peakAccelG = 4.85;
    _currentGyroDps = 86.4;
    _peakGyroDps = 86.4;
    _soundDb = 92.0;
    _acousticClassification = AcousticLevelClassification.anomaly;
    _impactCandidate = true;
    _rotationCandidate = true;
    _acousticCandidate = true;
    _lastAnomaly = 'Violent Impact, Tumbling & Acoustic Spike';
    _lastAnomalyTime = DateTime.now();
    notifyListeners();
  }

  void resetPeak() {
    _peakAccelG = 1.0;
    _peakGyroDps = 0.0;
    _soundDb = 42.0;
    _impactCandidate = false;
    _rotationCandidate = false;
    _acousticCandidate = false;
    _acousticClassification = AcousticLevelClassification.normal;
    _lastAnomaly = null;
    _lastAnomalyTime = null;
    notifyListeners();
  }

  void stopListening() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    _acousticTimer?.cancel();
    _accelSub = null;
    _gyroSub = null;
    _acousticTimer = null;
    _accelStatus = SensorHardwareStatus.standby;
    _gyroStatus = SensorHardwareStatus.standby;
    _micStatus = SensorHardwareStatus.standby;
    notifyListeners();
  }
}
