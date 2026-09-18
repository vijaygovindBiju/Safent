import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:uuid/uuid.dart';

import '../models/journey.dart';
import '../models/incident.dart';
import '../models/sos_message.dart';
import '../models/risk_fusion.dart';
import '../services/storage_service.dart';
import '../services/network_service.dart';
import '../services/location_service.dart';
import '../services/sensor_service.dart';
import '../services/risk_engine.dart';
import '../services/mesh_service.dart';

class SafetyProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final NetworkService network = NetworkService();
  final LocationService location = LocationService();
  final SensorService sensors = SensorService();
  final RiskEngine risk = RiskEngine();
  final MeshService mesh = MeshService();
  final Battery _battery = Battery();
  final Uuid _uuid = const Uuid();

  Journey? _activeJourney;
  Incident? _currentIncident;
  List<Incident> _incidentHistory = [];
  List<SOSMessage> _pendingSosQueue = [];

  int _batteryLevel = 78;
  int _dangerCountdown = 10;
  bool _isDangerActive = false;
  Timer? _countdownTimer;
  Timer? _journeyDurationTimer;

  // Demo Automation state
  bool _isDemoRunning = false;
  int _demoProgress = 0;
  String _demoStepText = '';
  final List<Timer> _demoTimers = [];

  Journey? get activeJourney => _activeJourney;
  Incident? get currentIncident => _currentIncident;
  List<Incident> get incidentHistory => _incidentHistory;
  List<SOSMessage> get pendingSosQueue => _pendingSosQueue;
  int get batteryLevel => _batteryLevel;
  int get dangerCountdown => _dangerCountdown;
  bool get isDangerActive => _isDangerActive;
  bool get isDemoRunning => _isDemoRunning;
  int get demoProgress => _demoProgress;
  String get demoStepText => _demoStepText;

  bool get isMonitoringActive =>
      _activeJourney != null &&
      (_activeJourney!.status == 'ACTIVE' || _activeJourney!.status == 'DANGER_SUSPECTED');

  Future<void> initialize() async {
    await _storage.init();
    await network.init();

    // Read real battery
    try {
      _batteryLevel = await _battery.batteryLevel;
    } catch (_) {
      _batteryLevel = 78;
    }

    // Load persisted data
    _activeJourney = await _storage.loadActiveJourney();
    _incidentHistory = await _storage.loadIncidents();
    _pendingSosQueue = await _storage.loadPendingSosQueue();

    if (_activeJourney != null && _activeJourney!.status == 'ACTIVE') {
      _startJourneyDurationTimer();
      sensors.startListening();
      location.startTracking();
    }

    // Listen for network recovery to auto-flush pending SOS
    network.addListener(_onNetworkChanged);
    sensors.addListener(_onSensorChanged);

    notifyListeners();
  }

  void _onNetworkChanged() {
    if (network.isOnline && _pendingSosQueue.isNotEmpty) {
      _flushPendingSosQueue();
    }
  }

  void _onSensorChanged() {
    if (!isMonitoringActive || _isDangerActive) return;

    // Evaluate risk with real sensor values
    if (sensors.impactCandidate || sensors.rotationCandidate) {
      final score = risk.evaluate(
        hasImpact: sensors.impactCandidate,
        hasRotation: sensors.rotationCandidate,
        hasAcoustic: sensors.acousticCandidate,
        isLateNight: true,
        isSimulated: false,
      );

      if (score.totalScore >= risk.riskThreshold) {
        triggerDangerDetected(isSimulated: false);
      }
    }
  }

  // --- Journey Lifecycle ---
  Future<void> startJourney({
    required String destination,
    required String journeyName,
    required String contactName,
    required String contactPhone,
    bool audio = true,
    bool motion = true,
    bool locationTracking = true,
    int expectedMinutes = 30,
  }) async {
    final now = DateTime.now();
    _activeJourney = Journey(
      id: 'JNY-${_uuid.v4().substring(0, 8).toUpperCase()}',
      destination: destination.isEmpty ? 'Kochi, Kerala' : destination,
      journeyName: journeyName.isEmpty ? 'Late-Night Transit Home' : journeyName,
      startTime: now,
      elapsedSeconds: 0,
      status: 'ACTIVE',
      location: location.currentLocation,
      battery: _batteryLevel,
      contact: TrustedContact(name: contactName, phone: contactPhone),
      audioMonitoring: audio,
      motionMonitoring: motion,
      locationMonitoring: locationTracking,
      expectedArrivalMinutes: expectedMinutes,
      breadcrumbs: [location.currentLocation],
    );

    await _storage.saveActiveJourney(_activeJourney);
    _startJourneyDurationTimer();
    sensors.startListening();
    await location.startTracking();

    notifyListeners();
  }

  void _startJourneyDurationTimer() {
    _journeyDurationTimer?.cancel();
    _journeyDurationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_activeJourney != null) {
        _activeJourney!.elapsedSeconds++;
        notifyListeners();
      }
    });
  }

  // --- Danger Detection ---
  void triggerDangerDetected({bool isSimulated = false}) {
    if (_isDangerActive) return;

    _isDangerActive = true;
    _dangerCountdown = 10;

    if (_activeJourney != null) {
      _activeJourney!.status = 'DANGER_SUSPECTED';
      _storage.saveActiveJourney(_activeJourney);
    }

    final score = isSimulated
        ? RiskFusionScore(
            impactScore: 40,
            audioScore: 25,
            rotationScore: 20,
            contextScore: 10,
            totalScore: 95,
            riskLevel: 'HIGH',
            isSimulated: true,
          )
        : risk.currentScore;

    _currentIncident = Incident(
      id: 'INC-${_uuid.v4().substring(0, 8).toUpperCase()}',
      journeyId: _activeJourney?.id ?? 'JNY-MANUAL',
      type: 'Possible Crash / Violent Impact',
      riskScore: score.totalScore,
      riskFusion: score,
      location: location.currentLocation,
      status: 'CONFIRMATION_PENDING',
      travellerName: 'Anonymous Traveller (Phone A)',
      battery: _batteryLevel,
      isSimulated: isSimulated,
      timeline: [
        IncidentEvent(
          id: 'EVT-1',
          title: 'Danger Detected',
          description: 'Multi-sensor risk fusion registered ${score.totalScore}/100 HIGH risk.',
          category: 'DETECTION',
          severity: 'CRITICAL',
        ),
        IncidentEvent(
          id: 'EVT-2',
          title: 'Safety Confirmation Challenge',
          description: '10-second countdown started to prevent false alarms.',
          category: 'SAFETY_CHECK',
          severity: 'WARNING',
        ),
      ],
    );

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_dangerCountdown <= 1) {
        timer.cancel();
        _dangerCountdown = 0;
        triggerImmediateSOS(isAuto: true);
      } else {
        _dangerCountdown--;
        notifyListeners();
      }
    });

    notifyListeners();
  }

  // --- Safety Confirmation (False-Positive Dismiss) ---
  void confirmSafe() {
    _countdownTimer?.cancel();
    _isDangerActive = false;
    _dangerCountdown = 10;

    if (_activeJourney != null) {
      _activeJourney!.status = 'ACTIVE';
      _storage.saveActiveJourney(_activeJourney);
    }

    if (_currentIncident != null) {
      _currentIncident!.status = 'CONFIRMED_SAFE';
      _currentIncident!.timeline.add(
        IncidentEvent(
          id: 'EVT-${_currentIncident!.timeline.length + 1}',
          title: 'User Confirmed Safe',
          description: "Traveller tapped 'I'M SAFE'. SOS dispatch successfully aborted.",
          category: 'SAFETY_CHECK',
          severity: 'SUCCESS',
        ),
      );
      _incidentHistory.insert(0, _currentIncident!);
      _storage.saveIncidents(_incidentHistory);
    }

    sensors.resetPeak();
    risk.reset();
    notifyListeners();
  }

  // --- Immediate or Automatic SOS Trigger ---
  Future<void> triggerImmediateSOS({bool isAuto = false}) async {
    _countdownTimer?.cancel();
    _isDangerActive = false;

    if (_activeJourney != null) {
      _activeJourney!.status = 'SOS_TRIGGERED';
      await _storage.saveActiveJourney(_activeJourney);
    }

    final incId = _currentIncident?.id ?? 'INC-${_uuid.v4().substring(0, 8).toUpperCase()}';
    final msgId = 'SOS-PKT-${_uuid.v4().substring(0, 8).toUpperCase()}';

    _currentIncident ??= Incident(
      id: incId,
      journeyId: _activeJourney?.id ?? 'JNY-MANUAL',
      type: 'Emergency SOS Triggered',
      riskScore: 95,
      riskFusion: RiskFusionScore(totalScore: 95, riskLevel: 'HIGH'),
      location: location.currentLocation,
      status: 'SOS_CREATED',
      travellerName: 'Anonymous Traveller (Phone A)',
      battery: _batteryLevel,
      timeline: [],
    );

    _currentIncident!.status = 'SOS_CREATED';
    _currentIncident!.timeline.add(
      IncidentEvent(
        id: 'EVT-SOS',
        title: isAuto ? 'Auto-SOS Triggered (Timeout)' : 'Manual Emergency SOS Pressed',
        description: 'Distress beacon activated. Generating encrypted PDU.',
        category: 'SOS',
        severity: 'CRITICAL',
      ),
    );

    // Create SOS packet
    final sosMessage = SOSMessage(
      messageId: msgId,
      incidentId: incId,
      originDeviceId: 'ANDROID_PHONE_A',
      currentNodeId: 'NODE_A',
      hopCount: 0,
      ttl: 300,
      status: network.isOnline ? 'UPLOADING' : 'QUEUED',
      encryptedPayload: 'AES-GCM-256:8f4c2b9a70e3d11b... [Encrypted GPS & Telemetry]',
      signature: 'ED25519-SIG:9b20e184... [Device A]',
      routeHistory: [
        RouteHop(
          nodeId: 'NODE_A',
          nodeName: 'Traveller Phone A',
          hopIndex: 0,
          protocol: 'BLE_5.2_EXT_ADV',
          actionTaken: 'Distress beacon initialized on origin device.',
        ),
      ],
    );

    // Offline-first queue
    _pendingSosQueue.add(sosMessage);
    await _storage.savePendingSosQueue(_pendingSosQueue);

    // Initialize mesh engine
    mesh.initializeWithSOS(sosMessage);

    // Add to incident history
    _incidentHistory.removeWhere((i) => i.id == incId);
    _incidentHistory.insert(0, _currentIncident!);
    await _storage.saveIncidents(_incidentHistory);

    // If online, immediately upload
    if (network.isOnline) {
      _flushPendingSosQueue();
    }

    notifyListeners();
  }

  // --- Network Recovery / Flush Pending SOS ---
  Future<void> _flushPendingSosQueue() async {
    if (_pendingSosQueue.isEmpty) return;

    for (final msg in _pendingSosQueue) {
      msg.status = 'DELIVERED';
    }
    _pendingSosQueue.clear();
    await _storage.savePendingSosQueue(_pendingSosQueue);

    if (_currentIncident != null) {
      _currentIncident!.status = 'DELIVERED';
      _currentIncident!.timeline.add(
        IncidentEvent(
          id: 'EVT-NET-FLUSH',
          title: 'SOS Uploaded via Cellular Recovery',
          description: 'Internet restored. Offline pending SOS successfully transmitted to cloud backend.',
          category: 'GATEWAY',
          severity: 'SUCCESS',
        ),
      );
      await _storage.saveIncidents(_incidentHistory);
    }

    notifyListeners();
  }

  // --- Responder Actions ---
  void acknowledgeIncident({String responder = 'Officer Radhakrishnan (Console #04)'}) {
    if (_currentIncident != null) {
      _currentIncident!.status = 'ACKNOWLEDGED';
      _currentIncident!.acknowledgedBy = responder;
      _currentIncident!.acknowledgedAt = DateTime.now();
      _currentIncident!.responderNotes = 'Ambulance 108 & Kochi Police Unit #04 dispatched.';
      _currentIncident!.timeline.add(
        IncidentEvent(
          id: 'EVT-ACK',
          title: 'Incident Acknowledged by Response Center',
          description: 'Dispatcher $responder verified incident and dispatched emergency units.',
          category: 'RESPONDER',
          severity: 'SUCCESS',
        ),
      );
      _storage.saveIncidents(_incidentHistory);
      notifyListeners();
    }
  }

  void resolveIncident() {
    if (_currentIncident != null) {
      _currentIncident!.status = 'RESOLVED';
      _currentIncident!.timeline.add(
        IncidentEvent(
          id: 'EVT-RES',
          title: 'Incident Resolved & Secured',
          description: 'Emergency units reached scene. Traveller verified safe.',
          category: 'RESPONDER',
          severity: 'SUCCESS',
        ),
      );
      _storage.saveIncidents(_incidentHistory);
    }
    if (_activeJourney != null) {
      _activeJourney!.status = 'COMPLETED';
      _storage.saveActiveJourney(_activeJourney);
    }
    notifyListeners();
  }

  // --- Automated 50-Second Demo Engine ---
  void runFullDemo() {
    stopDemo();
    resetDemo();

    _isDemoRunning = true;
    _demoProgress = 2;
    _demoStepText = '00s: Initializing safe journey toward Kochi...';

    // T+1s: Start Journey
    _demoTimers.add(Timer(const Duration(milliseconds: 1500), () {
      startJourney(
        destination: 'MG Road Metro Station, Kochi',
        journeyName: 'Late-Night Transit Home',
        contactName: 'Anjali Menon (Sister)',
        contactPhone: '+91 98470 12345',
      );
      _demoProgress = 10;
      _demoStepText = '00s: Journey active — Accelerometer, Gyroscope & GPS active.';
      notifyListeners();
    }));

    // T+5s: Network lost (OFFLINE)
    _demoTimers.add(Timer(const Duration(milliseconds: 5000), () {
      network.setManualOffline(true);
      _demoProgress = 20;
      _demoStepText = '05s: Traveller enters cellular dead-zone (OFFLINE). Mesh mode engaged.';
      notifyListeners();
    }));

    // T+10s: Anomaly detected
    _demoTimers.add(Timer(const Duration(milliseconds: 10000), () {
      _demoProgress = 30;
      _demoStepText = '10s: Monitoring sensors detect sudden vehicle deceleration.';
      notifyListeners();
    }));

    // T+14s: Risk becomes HIGH (95/100) & Challenge appears
    _demoTimers.add(Timer(const Duration(milliseconds: 14000), () {
      sensors.triggerSimulatedAnomaly();
      triggerDangerDetected(isSimulated: true);
      _demoProgress = 40;
      _demoStepText = '15s: Risk fusion reaches 95/100 HIGH! 10s challenge active.';
      notifyListeners();
    }));

    // T+20s: Challenge countdown ticking
    _demoTimers.add(Timer(const Duration(milliseconds: 20000), () {
      _demoProgress = 50;
      _demoStepText = "20s: 'Are you safe?' countdown ticking... Evaluating responsiveness.";
      notifyListeners();
    }));

    // T+25s: No response & SOS created
    _demoTimers.add(Timer(const Duration(milliseconds: 25000), () {
      triggerImmediateSOS(isAuto: true);
      _demoProgress = 60;
      _demoStepText = '28s: No response. SOS created! Queued locally without Internet.';
      notifyListeners();
    }));

    // T+30s: Relay Hop 1 (to Relay Phone B)
    _demoTimers.add(Timer(const Duration(milliseconds: 30000), () {
      mesh.advanceHop();
      _demoProgress = 70;
      _demoStepText = '32s: Peer found (Phone B in auto-rickshaw). Relayed via BLE 5.2.';
      notifyListeners();
    }));

    // T+35s: Relay Hop 2 (to Gateway Phone C with 5G)
    _demoTimers.add(Timer(const Duration(milliseconds: 35000), () {
      mesh.advanceHop();
      _demoProgress = 80;
      _demoStepText = '36s: Internet Gateway reached (Phone C with 5G). Uploading to cloud...';
      notifyListeners();
    }));

    // T+40s: Hop 3 (Backend receives SOS)
    _demoTimers.add(Timer(const Duration(milliseconds: 40000), () {
      mesh.advanceHop();
      _demoProgress = 88;
      _demoStepText = '40s: Cloud SOS Backend receives and decrypts payload.';
      notifyListeners();
    }));

    // T+45s: Hop 4 (Responder console alerted)
    _demoTimers.add(Timer(const Duration(milliseconds: 45000), () {
      mesh.advanceHop();
      _demoProgress = 94;
      _demoStepText = '45s: Responder notified! Dispatch sirens sounding at Command Console #04.';
      notifyListeners();
    }));

    // T+50s: Incident acknowledged
    _demoTimers.add(Timer(const Duration(milliseconds: 50000), () {
      acknowledgeIncident();
      _demoProgress = 100;
      _demoStepText = '50s: Incident acknowledged by dispatch! Units vectoring to MG Road.';
      Timer(const Duration(seconds: 4), () {
        _isDemoRunning = false;
        notifyListeners();
      });
      notifyListeners();
    }));
  }

  void stopDemo() {
    for (final t in _demoTimers) {
      t.cancel();
    }
    _demoTimers.clear();
    _isDemoRunning = false;
    _demoStepText = '';
    notifyListeners();
  }

  void resetDemo() {
    stopDemo();
    _countdownTimer?.cancel();
    _journeyDurationTimer?.cancel();

    _isDangerActive = false;
    _dangerCountdown = 10;
    _activeJourney = null;
    _currentIncident = null;
    _pendingSosQueue.clear();

    sensors.resetPeak();
    risk.reset();
    mesh.reset();
    network.setManualOffline(false);

    _storage.saveActiveJourney(null);
    _storage.savePendingSosQueue([]);

    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _journeyDurationTimer?.cancel();
    stopDemo();
    network.removeListener(_onNetworkChanged);
    sensors.removeListener(_onSensorChanged);
    super.dispose();
  }
}
