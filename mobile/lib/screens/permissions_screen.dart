import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../services/permission_service.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final PermissionService _permissionService = PermissionService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await _permissionService.checkAllPermissions();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions & Privacy Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Status',
            onPressed: _refresh,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : AnimatedBuilder(
              animation: _permissionService,
              builder: (context, _) {
                final permissions = [
                  AppPermissionType.location,
                  AppPermissionType.microphone,
                  AppPermissionType.notifications,
                  AppPermissionType.bluetooth,
                ];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Explainer
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.surfaceBorder),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.security_outlined, color: AppColors.primary, size: 28),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'On-Demand Permission Policy',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Permissions are requested only when features are activated. All sensor data is processed strictly on-device.',
                                    style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Hardware & Service Access',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Permission Cards
                      ...permissions.map((type) {
                        final detail = _permissionService.getDetail(type);
                        return _buildPermissionCard(context, detail);
                      }),

                      const SizedBox(height: 20),

                      // System Settings Button
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.surfaceBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.settings_suggest_outlined, size: 20, color: AppColors.textSecondary),
                                SizedBox(width: 8),
                                Text(
                                  'Need to adjust permissions manually?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'If permissions were permanently denied or restricted by Android battery optimization, enable them directly in Android system settings.',
                              style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.3),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  await _permissionService.openSystemSettings();
                                },
                                icon: const Icon(Icons.open_in_new, size: 16),
                                label: const Text('OPEN ANDROID APP SETTINGS'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.textPrimary,
                                  side: const BorderSide(color: AppColors.surfaceBorder),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildPermissionCard(BuildContext context, PermissionDetail detail) {
    final state = detail.state;
    final isGranted = state == PermissionUiState.granted;
    final isPermanentlyDenied = state == PermissionUiState.permanentlyDenied;

    IconData icon;
    switch (detail.type) {
      case AppPermissionType.location:
        icon = Icons.location_on_outlined;
        break;
      case AppPermissionType.microphone:
        icon = Icons.mic_none_outlined;
        break;
      case AppPermissionType.notifications:
        icon = Icons.notifications_none_outlined;
        break;
      case AppPermissionType.bluetooth:
        icon = Icons.bluetooth_outlined;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGranted ? AppColors.safe.withValues(alpha: 0.3) : AppColors.surfaceBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isGranted
                      ? AppColors.safe.withValues(alpha: 0.15)
                      : isPermanentlyDenied
                          ? AppColors.emergency.withValues(alpha: 0.15)
                          : AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isGranted
                      ? AppColors.safe
                      : isPermanentlyDenied
                          ? AppColors.emergency
                          : AppColors.warning,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detail.description,
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(state),
            ],
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    detail.whyNeeded,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                  ),
                ),
              ],
            ),
          ),

          if (!isGranted) ...[
            const SizedBox(height: 10),
            Text(
              detail.recoveryInstruction,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isPermanentlyDenied ? AppColors.emergency : AppColors.warning,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  if (isPermanentlyDenied) {
                    await _permissionService.openSystemSettings();
                  } else {
                    await _permissionService.requestPermission(detail.type);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPermanentlyDenied ? AppColors.surfaceBorder : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  isPermanentlyDenied ? 'OPEN SETTINGS' : 'GRANT PERMISSION',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(PermissionUiState state) {
    Color bg;
    Color fg;
    String text;
    IconData icon;

    switch (state) {
      case PermissionUiState.granted:
        bg = AppColors.safe.withValues(alpha: 0.15);
        fg = AppColors.safe;
        text = 'GRANTED';
        icon = Icons.check_circle_rounded;
        break;
      case PermissionUiState.denied:
        bg = AppColors.warning.withValues(alpha: 0.15);
        fg = AppColors.warning;
        text = 'DENIED';
        icon = Icons.remove_circle_outline;
        break;
      case PermissionUiState.permanentlyDenied:
        bg = AppColors.emergency.withValues(alpha: 0.15);
        fg = AppColors.emergency;
        text = 'BLOCKED';
        icon = Icons.block_rounded;
        break;
      case PermissionUiState.unavailable:
        bg = AppColors.textMuted.withValues(alpha: 0.15);
        fg = AppColors.textMuted;
        text = 'N/A';
        icon = Icons.help_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg),
          ),
        ],
      ),
    );
  }
}
