import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';
import '../providers/safety_provider.dart';

class SafetyChallengeModal extends StatelessWidget {
  final SafetyProvider safety;
  final bool isOverlay;

  const SafetyChallengeModal({
    super.key,
    required this.safety,
    this.isOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final countdown = safety.dangerCountdown;
    final totalSec = safety.configuredCountdownDuration;
    final progress = totalSec > 0 ? (countdown / totalSec).clamp(0.0, 1.0) : 0.0;
    final incident = safety.currentIncident;
    final triggerText = incident != null && incident.type.isNotEmpty
        ? incident.type
        : 'High Risk Telemetry Anomaly';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E0E12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.emergency, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.emergency.withValues(alpha: 0.4),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Danger Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.emergency.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: AppColors.emergency,
                  size: 28,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'POSSIBLE DANGER DETECTED',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.emergency,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Anomaly description
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Trigger: $triggerText',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Are you safe? Confirm within the window or emergency SOS will dispatch automatically.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 16),

          // Countdown Dial with Circular Progress Ring
          SizedBox(
            width: 86,
            height: 86,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 86,
                  height: 86,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    color: countdown <= 3 ? AppColors.emergency : AppColors.warning,
                    backgroundColor: Colors.white10,
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Text(
                      '$countdown',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: countdown <= 3 ? AppColors.emergency : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons: I'M SAFE vs SEND SOS NOW
          Row(
            children: [
              Expanded(
                flex: 5,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    safety.confirmSafe();
                  },
                  icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  label: const Text(
                    "I'M SAFE",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    safety.triggerImmediateSOS(isAuto: false);
                  },
                  icon: const Icon(Icons.sos, color: AppColors.emergency, size: 18),
                  label: const Text(
                    'SOS NOW',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.emergency,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.emergency, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
