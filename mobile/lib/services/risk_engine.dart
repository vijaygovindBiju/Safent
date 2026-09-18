import 'package:flutter/foundation.dart';
import '../models/risk_fusion.dart';

class RiskEngine extends ChangeNotifier {
  static final RiskEngine _instance = RiskEngine._internal();
  factory RiskEngine() => _instance;
  RiskEngine._internal();

  int _riskThreshold = 75;
  RiskFusionScore _currentScore = RiskFusionScore();

  RiskFusionScore get currentScore => _currentScore;
  int get riskThreshold => _riskThreshold;
  bool get isHighRisk => _currentScore.totalScore >= _riskThreshold;

  void updateThreshold(int threshold) {
    _riskThreshold = threshold;
    notifyListeners();
  }

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

    int total = impact + audio + rotation + context;

    String level = 'NORMAL';
    if (total >= 75) {
      level = 'HIGH';
    } else if (total >= 40) {
      level = 'MODERATE';
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
    notifyListeners();
  }
}
