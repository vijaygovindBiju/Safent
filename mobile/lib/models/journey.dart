import 'dart:convert';

class LocationPoint {
  final double latitude;
  final double longitude;
  final double accuracy;
  final String landmark;
  final double speedKmh;
  final double heading;
  final DateTime timestamp;

  LocationPoint({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.landmark,
    this.speedKmh = 0.0,
    this.heading = 0.0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'landmark': landmark,
      'speedKmh': speedKmh,
      'heading': heading,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LocationPoint.fromMap(Map<String, dynamic> map) {
    return LocationPoint(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      accuracy: (map['accuracy'] as num).toDouble(),
      landmark: map['landmark'] ?? '',
      speedKmh: ((map['speedKmh'] ?? 0) as num).toDouble(),
      heading: ((map['heading'] ?? 0) as num).toDouble(),
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class TrustedContact {
  final String name;
  final String phone;
  final String relationship;

  TrustedContact({
    required this.name,
    required this.phone,
    this.relationship = 'Emergency Contact',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'relationship': relationship,
    };
  }

  factory TrustedContact.fromMap(Map<String, dynamic> map) {
    return TrustedContact(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      relationship: map['relationship'] ?? 'Emergency Contact',
    );
  }
}

class Journey {
  final String id;
  final String destination;
  final String journeyName;
  final DateTime startTime;
  int elapsedSeconds;
  String status; // 'SCHEDULED', 'ACTIVE', 'DANGER_SUSPECTED', 'SOS_TRIGGERED', 'COMPLETED'
  LocationPoint location;
  int battery;
  TrustedContact contact;
  bool audioMonitoring;
  bool motionMonitoring;
  bool locationMonitoring;
  int expectedArrivalMinutes;
  List<LocationPoint> breadcrumbs;

  Journey({
    required this.id,
    required this.destination,
    required this.journeyName,
    required this.startTime,
    this.elapsedSeconds = 0,
    this.status = 'SCHEDULED',
    required this.location,
    this.battery = 100,
    required this.contact,
    this.audioMonitoring = true,
    this.motionMonitoring = true,
    this.locationMonitoring = true,
    this.expectedArrivalMinutes = 30,
    List<LocationPoint>? breadcrumbs,
  }) : breadcrumbs = breadcrumbs ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'destination': destination,
      'journeyName': journeyName,
      'startTime': startTime.toIso8601String(),
      'elapsedSeconds': elapsedSeconds,
      'status': status,
      'location': location.toMap(),
      'battery': battery,
      'contact': contact.toMap(),
      'audioMonitoring': audioMonitoring,
      'motionMonitoring': motionMonitoring,
      'locationMonitoring': locationMonitoring,
      'expectedArrivalMinutes': expectedArrivalMinutes,
      'breadcrumbs': breadcrumbs.map((p) => p.toMap()).toList(),
    };
  }

  factory Journey.fromMap(Map<String, dynamic> map) {
    return Journey(
      id: map['id'],
      destination: map['destination'] ?? 'Kochi, Kerala',
      journeyName: map['journeyName'] ?? 'Safe Journey',
      startTime: DateTime.parse(map['startTime']),
      elapsedSeconds: map['elapsedSeconds'] ?? 0,
      status: map['status'] ?? 'SCHEDULED',
      location: LocationPoint.fromMap(map['location']),
      battery: map['battery'] ?? 100,
      contact: TrustedContact.fromMap(map['contact']),
      audioMonitoring: map['audioMonitoring'] ?? true,
      motionMonitoring: map['motionMonitoring'] ?? true,
      locationMonitoring: map['locationMonitoring'] ?? true,
      expectedArrivalMinutes: map['expectedArrivalMinutes'] ?? 30,
      breadcrumbs: (map['breadcrumbs'] as List<dynamic>?)
              ?.map((p) => LocationPoint.fromMap(p))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());
  factory Journey.fromJson(String source) => Journey.fromMap(json.decode(source));
}
