import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/safety_provider.dart';

class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  double _holdProgress = 0.0;
  Timer? _holdTimer;

  void _startHold(SafetyProvider safety) {
    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _holdProgress += 0.035; // ~1.5 seconds to reach 1.0
        if (_holdProgress >= 1.0) {
          _holdProgress = 1.0;
          timer.cancel();
          safety.triggerImmediateSOS();
        }
      });
    });
  }

  void _endHold() {
    _holdTimer?.cancel();
    setState(() {
      _holdProgress = 0.0;
    });
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safety = context.watch<SafetyProvider>();
    final sensors = safety.sensors;
    final risk = safety.risk.currentScore;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Surveillance & SOS'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // High Urgency 10s Confirmation Overlay if danger is active
            if (safety.isDangerActive)
              _buildDangerChallengeCard(context, safety),

            if (safety.isDangerActive)
              const SizedBox(height: 20),

            // Emergency HOLD FOR SOS Primary Button
            _buildHoldSosCard(context, safety),

            const SizedBox(height: 22),

            // Real Sensor Telemetry
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ON-DEVICE HARDWARE SENSORS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.textMuted,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: sensors.isRealHardware
                        ? AppColors.success.withValues(alpha: 0.15)
                        : AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    sensors.isRealHardware ? 'REAL HARDWARE SENSORS' : 'SENSOR SIMULATION',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: sensors.isRealHardware ? AppColors.success : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 3 Sensor Readouts
            Row(
              children: [
                Expanded(
                  child: _sensorBox(
                    label: 'ACCELERATION',
                    value: '${sensors.currentAccelG}G',
                    subtitle: 'Peak: ${sensors.peakAccelG}G',
                    icon: Icons.speed,
                    color: sensors.impactCandidate ? AppColors.emergency : AppColors.cyanAccent,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _sensorBox(
                    label: 'ROTATION',
                    value: '${sensors.currentGyroDps}°/s',
                    subtitle: 'Peak: ${sensors.peakGyroDps}°/s',
                    icon: Icons.rotate_right,
                    color: sensors.rotationCandidate ? AppColors.emergency : AppColors.meshIndigo,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _sensorBox(
                    label: 'ACOUSTIC',
                    value: '${sensors.soundDb.toInt()} dB',
                    subtitle: sensors.acousticClassification.name.toUpperCase(),
                    icon: Icons.mic_none,
                    color: sensors.acousticCandidate ? AppColors.emergency : AppColors.warning,
                  ),
                ),
              ],
            ),

            if (sensors.lastAnomaly != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.emergency.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.emergency.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.emergency),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Recent Anomaly: ${sensors.lastAnomaly}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.emergency,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 22),

            // Multi-Sensor Risk Fusion Model
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'MULTI-SENSOR RISK FUSION',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'SCORE: ${risk.totalScore}/100 (${risk.riskLevel})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: risk.totalScore >= safety.risk.riskThreshold
                              ? AppColors.emergency
                              : AppColors.safe,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _riskBar('Impact / Rapid Deceleration (>3.8G)', risk.impactScore, 40),
                  _riskBar('Acoustic Distress Spike (>80 dB)', risk.audioScore, 25),
                  _riskBar('Sudden Vehicle Tumble (>80°/s)', risk.rotationScore, 20),
                  _riskBar('Late-Night Journey Context (>22:00)', risk.contextScore, 10),
                  const SizedBox(height: 8),
                  Text(
                    'Threshold: ${safety.risk.riskThreshold}/100 • False-Alarm Corroboration Guard Active',
                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Simulation Trigger Button for Demo
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  sensors.triggerSimulatedAnomaly();
                  safety.triggerDangerDetected(isSimulated: true);
                },
                icon: const Icon(Icons.warning_amber, color: AppColors.warning),
                label: const Text(
                  'SIMULATE DANGEROUS EVENT (DEMO)',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.warning),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerChallengeCard(BuildContext context, SafetyProvider safety) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.emergencyDark.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.emergency, width: 2),
      ),
      child: Column(
        children: [
          const Icon(Icons.warning, color: AppColors.emergency, size: 40),
          const SizedBox(height: 8),
          const Text(
            '⚠ POSSIBLE DANGER DETECTED',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Are you safe? Confirm within the window or SOS dispatches automatically.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),

          // Countdown Dial
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(color: AppColors.emergency, width: 3),
            ),
            child: Center(
              child: Text(
                '${safety.dangerCountdown}',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Dual Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => safety.confirmSafe(),
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text("I'M SAFE", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => safety.triggerImmediateSOS(),
                  icon: const Icon(Icons.sos, color: Colors.white),
                  label: const Text('SEND SOS NOW', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emergency,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHoldSosCard(BuildContext context, SafetyProvider safety) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.emergency.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'EMERGENCY SOS TRIGGER',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.emergency),
              ),
              Text(
                'HOLD 1.5s',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Radial Hold Button
          GestureDetector(
            onTapDown: (_) => _startHold(safety),
            onTapUp: (_) => _endHold(),
            onTapCancel: () => _endHold(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: CircularProgressIndicator(
                    value: _holdProgress,
                    strokeWidth: 8,
                    color: AppColors.emergency,
                    backgroundColor: AppColors.border,
                  ),
                ),
                Container(
                  width: 106,
                  height: 106,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.emergency, AppColors.emergencyDark],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emergency.withValues(alpha: 0.4),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32),
                      SizedBox(height: 2),
                      Text(
                        'HOLD FOR',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white70),
                      ),
                      Text(
                        'SOS',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Text(
            'Press and hold for 1.5s to trigger encrypted mesh SOS dispatch.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _sensorBox({
    required String label,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color)),
          Text(subtitle, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _riskBar(String label, int score, int maxScore) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              Text('+$score', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.cyanAccent)),
            ],
          ),
          const SizedBox(height: 3),
          LinearProgressIndicator(
            value: score / maxScore,
            backgroundColor: AppColors.border,
            color: score > 0 ? AppColors.cyanAccent : AppColors.border,
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }
}
