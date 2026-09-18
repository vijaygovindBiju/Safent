import 'package:flutter/foundation.dart';
import '../models/risk_fusion.dart';

class RiskEngine extends ChangeNotifier {
  static final RiskEngine _instance = RiskEngine._internal();
  factory RiskEngine() => _instance;
  RiskEngine._internal();

  int _riskThreshold = 70;
  RiskFusionScore _currentScore = RiskFusionScore();
  final List<String> _activeSignalDescriptions = [];

  RiskFusionScore get currentScore => _currentScore;
  int get riskThreshold => _riskThreshold;
  List<String> get activeSignalDescriptions => _activeSignalDescriptions;
  bool get isHighRisk => _currentScore.totalScore >= _riskThreshold;

  void updateThreshold(int threshold) {
    _riskThreshold = threshold;
    notifyListeners();
  }

  /// Evaluates multi-signal fusion:
  /// - Impact / Sudden Deceleration: +40
  /// - Acoustic Anomaly Spike: +25
  /// - Sudden Rotation / Tumble: +20
  /// - Late-Night Context (10 PM - 5 AM): +10
  RiskFusionScore evaluate({
    required bool hasImpact,
    required bool hasRotation,
    required bool hasAcoustic,
    required bool isLateNight,
    bool isSimulated = false,
  }) {
    int impact = hasImpact ? 40 : 0;
    int audio = hasAcoustic ? 25 : 0;
    int rotation = hasRotation ? 20 : 0;
    int context = isLateNight ? 10 : 0;

    int total = (impact + audio + rotation + context).clamp(0, 100);

    _activeSignalDescriptions.clear();
    if (hasImpact) _activeSignalDescriptions.add('Violent Deceleration / Impact (+40)');
    if (hasAcoustic) _activeSignalDescriptions.add('Acoustic Spike / Shatter (+25)');
    if (hasRotation) _activeSignalDescriptions.add('Vehicle Rollover / Tumbling (+20)');
    if (isLateNight) _activeSignalDescriptions.add('Late-Night High-Risk Window (+10)');

    // Risk Level Categorization
    String level = 'LOW';
    if (total >= _riskThreshold) {
      level = 'HIGH';
    } else if (total >= 40) {
      level = 'MEDIUM';
    }

    _currentScore = RiskFusionScore(
      impactScore: impact,
      audioScore: audio,
      rotationScore: rotation,
      contextScore: context,
      totalScore: total,
      riskLevel: level,
      detectedAt: DateTime.now(),
      isSimulated: isSimulated,
    );

    notifyListeners();
    return _currentScore;
  }

  void reset() {
    _currentScore = RiskFusionScore();
    _activeSignalDescriptions.clear();
    notifyListeners();
  }
}
