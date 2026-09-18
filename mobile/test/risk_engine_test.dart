import 'package:flutter_test/flutter_test.dart';
import 'package:travel_sos_mesh/services/risk_engine.dart';

void main() {
  group('RiskFusionEngine Multi-Sensor & False-Positive Damping (Phase 10 & 28)', () {
    late RiskEngine engine;

    setUp(() {
      engine = RiskEngine();
      engine.riskThreshold = 70;
      engine.reset();
    });

    test('Single impact spike does not breach threshold (False-positive damping)', () {
      final score = engine.evaluate(
        hasImpact: true,
        hasRotation: false,
        hasAcoustic: false,
        isLateNight: false,
      );

      // Impact only = +40
      expect(score.totalScore, equals(40));
      expect(score.riskLevel, equals('MEDIUM'));
      expect(engine.isHighRisk, isFalse);
    });

    test('Single acoustic spike does not breach threshold', () {
      final score = engine.evaluate(
        hasImpact: false,
        hasRotation: false,
        hasAcoustic: true,
        isLateNight: false,
      );

      // Acoustic only = +25
      expect(score.totalScore, equals(25));
      expect(score.riskLevel, equals('LOW'));
      expect(engine.isHighRisk, isFalse);
    });

    test('Multi-sensor corroboration (Impact + Acoustic + Late Night) breaches threshold', () {
      final score = engine.evaluate(
        hasImpact: true,
        hasRotation: false,
        hasAcoustic: true,
        isLateNight: true,
      );

      // 40 + 25 + 10 = 75 >= 70
      expect(score.totalScore, equals(75));
      expect(score.riskLevel, equals('HIGH'));
      expect(engine.isHighRisk, isTrue);
    });

    test('Extreme rollover accident (Impact + Rotation + Acoustic + Night) reaches near maximum', () {
      final score = engine.evaluate(
        hasImpact: true,
        hasRotation: true,
        hasAcoustic: true,
        isLateNight: true,
      );

      // 40 + 20 + 25 + 10 = 95
      expect(score.totalScore, equals(95));
      expect(score.riskLevel, equals('HIGH'));
      expect(engine.isHighRisk, isTrue);
    });

    test('Dynamic threshold adjustment affects high-risk detection', () {
      engine.riskThreshold = 80;
      final score = engine.evaluate(
        hasImpact: true,
        hasRotation: false,
        hasAcoustic: true,
        isLateNight: true,
      );

      expect(score.totalScore, equals(75));
      expect(engine.isHighRisk, isFalse); // Below new 80 threshold

      engine.riskThreshold = 60;
      expect(engine.isHighRisk, isTrue); // Above 60 threshold
    });
  });
}
