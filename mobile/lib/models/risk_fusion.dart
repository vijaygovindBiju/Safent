class SensorTelemetry {
  final double accelMagnitude; // in G
  final double gyroMagnitude;  // in deg/s
  final double soundDb;        // in dB
  final double speedKmh;
  final bool isNightTime;
  final bool isRealHardware;

  SensorTelemetry({
    this.accelMagnitude = 1.0,
    this.gyroMagnitude = 0.0,
    this.soundDb = 45.0,
    this.speedKmh = 0.0,
    this.isNightTime = true,
    this.isRealHardware = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'accelMagnitude': accelMagnitude,
      'gyroMagnitude': gyroMagnitude,
      'soundDb': soundDb,
      'speedKmh': speedKmh,
      'isNightTime': isNightTime,
      'isRealHardware': isRealHardware,
    };
  }

  factory SensorTelemetry.fromMap(Map<String, dynamic> map) {
    return SensorTelemetry(
      accelMagnitude: ((map['accelMagnitude'] ?? 1.0) as num).toDouble(),
      gyroMagnitude: ((map['gyroMagnitude'] ?? 0.0) as num).toDouble(),
      soundDb: ((map['soundDb'] ?? 45.0) as num).toDouble(),
      speedKmh: ((map['speedKmh'] ?? 0.0) as num).toDouble(),
      isNightTime: map['isNightTime'] ?? true,
      isRealHardware: map['isRealHardware'] ?? true,
    );
  }
}

class RiskFusionScore {
  final int impactScore;    // e.g. +40
  final int audioScore;     // e.g. +25
  final int rotationScore;  // e.g. +20
  final int contextScore;   // e.g. +10
  final int totalScore;     // 0 to 100
  final String riskLevel;   // 'NORMAL', 'MODERATE', 'HIGH', 'CRITICAL'
  final DateTime detectedAt;
  final bool isSimulated;

  RiskFusionScore({
    this.impactScore = 0,
    this.audioScore = 0,
    this.rotationScore = 0,
    this.contextScore = 0,
    this.totalScore = 0,
    this.riskLevel = 'NORMAL',
    DateTime? detectedAt,
    this.isSimulated = false,
  }) : detectedAt = detectedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'impactScore': impactScore,
      'audioScore': audioScore,
      'rotationScore': rotationScore,
      'contextScore': contextScore,
      'totalScore': totalScore,
      'riskLevel': riskLevel,
      'detectedAt': detectedAt.toIso8601String(),
      'isSimulated': isSimulated,
    };
  }

  factory RiskFusionScore.fromMap(Map<String, dynamic> map) {
    return RiskFusionScore(
      impactScore: map['impactScore'] ?? 0,
      audioScore: map['audioScore'] ?? 0,
      rotationScore: map['rotationScore'] ?? 0,
      contextScore: map['contextScore'] ?? 0,
      totalScore: map['totalScore'] ?? 0,
      riskLevel: map['riskLevel'] ?? 'NORMAL',
      detectedAt: DateTime.parse(map['detectedAt'] ?? DateTime.now().toIso8601String()),
      isSimulated: map['isSimulated'] ?? false,
    );
  }
}
