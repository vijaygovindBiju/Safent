import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';

class RadialHoldSosButton extends StatefulWidget {
  final VoidCallback onTriggered;
  final double size;
  final String label;
  final bool compact;

  const RadialHoldSosButton({
    super.key,
    required this.onTriggered,
    this.size = 130.0,
    this.label = 'SOS',
    this.compact = false,
  });

  @override
  State<RadialHoldSosButton> createState() => _RadialHoldSosButtonState();
}

class _RadialHoldSosButtonState extends State<RadialHoldSosButton>
    with SingleTickerProviderStateMixin {
  double _holdProgress = 0.0;
  Timer? _holdTimer;
  DateTime? _holdStartTime;
  static const int _holdDurationMs = 1500;

  void _startHold() {
    HapticFeedback.mediumImpact();
    _holdStartTime = DateTime.now();
    _holdTimer?.cancel();

    _holdTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_holdStartTime == null) return;
      final elapsed = DateTime.now().difference(_holdStartTime!).inMilliseconds;
      final progress = (elapsed / _holdDurationMs).clamp(0.0, 1.0);

      setState(() {
        _holdProgress = progress;
      });

      if (progress >= 1.0) {
        timer.cancel();
        _holdTimer = null;
        _holdStartTime = null;
        HapticFeedback.heavyImpact();
        widget.onTriggered();
        setState(() {
          _holdProgress = 0.0;
        });
      }
    });
  }

  void _cancelHold() {
    if (_holdProgress > 0.0 && _holdProgress < 1.0) {
      HapticFeedback.selectionClick();
    }
    _holdTimer?.cancel();
    _holdTimer = null;
    _holdStartTime = null;
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
    final s = widget.size;
    final innerS = widget.compact ? s - 10 : s - 24;

    return GestureDetector(
      onTapDown: (_) => _startHold(),
      onTapUp: (_) => _cancelHold(),
      onTapCancel: () => _cancelHold(),
      child: SizedBox(
        width: s,
        height: s,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Radial Progress Ring
            SizedBox(
              width: s,
              height: s,
              child: CircularProgressIndicator(
                value: _holdProgress,
                strokeWidth: widget.compact ? 4 : 8,
                color: AppColors.emergency,
                backgroundColor: AppColors.emergencyDark.withValues(alpha: 0.3),
              ),
            ),

            // Inner SOS Core
            Container(
              width: innerS,
              height: innerS,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: _holdProgress > 0
                      ? [AppColors.emergencyLight, AppColors.emergency]
                      : [AppColors.emergency, AppColors.emergencyDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emergency.withValues(
                      alpha: _holdProgress > 0 ? 0.6 : 0.35,
                    ),
                    blurRadius: _holdProgress > 0 ? 24 : 14,
                    spreadRadius: _holdProgress > 0 ? 4 : 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: widget.compact ? 18 : 32,
                  ),
                  if (!widget.compact) ...[
                    const SizedBox(height: 2),
                    const Text(
                      'HOLD 1.5s',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ] else ...[
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
