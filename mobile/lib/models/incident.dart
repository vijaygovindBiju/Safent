import 'dart:convert';
import 'journey.dart';
import 'risk_fusion.dart';

class IncidentEvent {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final String category; // 'DETECTION', 'SAFETY_CHECK', 'SOS', 'MESH', 'GATEWAY', 'RESPONDER'
  final String severity; // 'INFO', 'WARNING', 'CRITICAL', 'SUCCESS'

  IncidentEvent({
    required this.id,
    required this.title,
    required this.description,
    DateTime? timestamp,
    required this.category,
    this.severity = 'INFO',
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'category': category,
      'severity': severity,
    };
  }

  factory IncidentEvent.fromMap(Map<String, dynamic> map) {
    return IncidentEvent(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      category: map['category'] ?? 'DETECTION',
      severity: map['severity'] ?? 'INFO',
    );
  }
}

class Incident {
  final String id;
  final String journeyId;
  final String type;
  final int riskScore;
  final RiskFusionScore riskFusion;
  final DateTime timestamp;
  final LocationPoint location;
  String status; // 'DETECTED', 'CONFIRMATION_PENDING', 'CONFIRMED_SAFE', 'SOS_CREATED', 'RELAY_FOUND', 'GATEWAY_FOUND', 'DELIVERED', 'ACKNOWLEDGED', 'RESOLVED'
  final String travellerName;
  final int battery;
  String? acknowledgedBy;
  DateTime? acknowledgedAt;
  String? responderNotes;
  final bool isSimulated;
  List<IncidentEvent> timeline;

  Incident({
    required this.id,
    required this.journeyId,
    required this.type,
    required this.riskScore,
    required this.riskFusion,
    DateTime? timestamp,
    required this.location,
    this.status = 'DETECTED',
    required this.travellerName,
    required this.battery,
    this.acknowledgedBy,
    this.acknowledgedAt,
    this.responderNotes,
    this.isSimulated = false,
    List<IncidentEvent>? timeline,
  })  : timestamp = timestamp ?? DateTime.now(),
        timeline = timeline ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'journeyId': journeyId,
      'type': type,
      'riskScore': riskScore,
      'riskFusion': riskFusion.toMap(),
      'timestamp': timestamp.toIso8601String(),
      'location': location.toMap(),
      'status': status,
      'travellerName': travellerName,
      'battery': battery,
      'acknowledgedBy': acknowledgedBy,
      'acknowledgedAt': acknowledgedAt?.toIso8601String(),
      'responderNotes': responderNotes,
      'isSimulated': isSimulated,
      'timeline': timeline.map((e) => e.toMap()).toList(),
    };
  }

  factory Incident.fromMap(Map<String, dynamic> map) {
    return Incident(
      id: map['id'],
      journeyId: map['journeyId'] ?? '',
      type: map['type'] ?? 'Emergency SOS',
      riskScore: map['riskScore'] ?? 95,
      riskFusion: RiskFusionScore.fromMap(map['riskFusion'] ?? {}),
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      location: LocationPoint.fromMap(map['location']),
      status: map['status'] ?? 'DETECTED',
      travellerName: map['travellerName'] ?? 'Traveller',
      battery: map['battery'] ?? 100,
      acknowledgedBy: map['acknowledgedBy'],
      acknowledgedAt: map['acknowledgedAt'] != null ? DateTime.parse(map['acknowledgedAt']) : null,
      responderNotes: map['responderNotes'],
      isSimulated: map['isSimulated'] ?? false,
      timeline: (map['timeline'] as List<dynamic>?)
              ?.map((e) => IncidentEvent.fromMap(e))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());
  factory Incident.fromJson(String source) => Incident.fromMap(json.decode(source));
}
