import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/constants/app_colors.dart';
import '../providers/safety_provider.dart';
import '../services/permission_service.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  final _destController = TextEditingController(text: 'MG Road Metro Station, Kochi');
  final _contactNameController = TextEditingController(text: 'Anjali Menon (Sister)');
  final _contactPhoneController = TextEditingController(text: '+91 98470 12345');

  bool _audio = true;
  bool _motion = true;
  bool _location = true;

  @override
  void dispose() {
    _destController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final hrs = seconds ~/ 3600;
    final mins = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hrs.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final safety = context.watch<SafetyProvider>();
    final journey = safety.activeJourney;
    final currentPos = safety.location.currentLocation;

    return Scaffold(
      appBar: AppBar(
        title: Text(journey == null ? 'Initialize Journey' : 'Live Safe Journey'),
        actions: [
          IconButton(
            tooltip: 'Toggle Network Mode',
            icon: Icon(
              safety.network.isOnline ? Icons.wifi : Icons.wifi_off,
              color: safety.network.isOnline ? AppColors.success : AppColors.warning,
            ),
            onPressed: () => safety.network.toggleManualOffline(),
          ),
        ],
      ),
      body: journey == null
          ? _buildSetupView(context, safety)
          : _buildActiveView(context, safety, journey, currentPos),
    );
  }

  Widget _buildSetupView(BuildContext context, SafetyProvider safety) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ROUTE CONFIGURATION',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          // Destination Input
          TextField(
            controller: _destController,
            decoration: InputDecoration(
              labelText: 'Destination',
              prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.cyanAccent),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Quick Presets
          Wrap(
            spacing: 8,
            children: [
              _presetChip('MG Road Metro', 'MG Road Metro Station, Kochi'),
              _presetChip('Marine Drive', 'Marine Drive Walkway, Ernakulam'),
              _presetChip('Kakkanad InfoPark', 'InfoPark Expressway, Kakkanad'),
            ],
          ),

          const SizedBox(height: 18),

          const Text(
            'EMERGENCY TRUSTED CONTACT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _contactNameController,
            decoration: InputDecoration(
              labelText: 'Contact Name',
              prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: _contactPhoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'ON-DEVICE MONITORING SENSORS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),

          SwitchListTile(
            title: const Text('Audio Anomaly Detection', style: TextStyle(fontSize: 14)),
            subtitle: const Text('Local acoustic scream & shatter evaluation', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            value: _audio,
            activeThumbColor: AppColors.cyanAccent,
            onChanged: (val) => setState(() => _audio = val),
          ),

          SwitchListTile(
            title: const Text('Motion / Impact Detection', style: TextStyle(fontSize: 14)),
            subtitle: const Text('3-axis Accelerometer & Gyroscope monitoring', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            value: _motion,
            activeThumbColor: AppColors.cyanAccent,
            onChanged: (val) => setState(() => _motion = val),
          ),

          SwitchListTile(
            title: const Text('GPS Location Breadcrumbs', style: TextStyle(fontSize: 14)),
            subtitle: const Text('Adaptive battery-efficient location tracking', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            value: _location,
            activeThumbColor: AppColors.cyanAccent,
            onChanged: (val) => setState(() => _location = val),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final permService = PermissionService();
                if (_location) {
                  await permService.requestPermission(AppPermissionType.location);
                }
                if (_audio) {
                  await permService.requestPermission(AppPermissionType.microphone);
                }
                await permService.requestPermission(AppPermissionType.notifications);

                safety.startJourney(
                  destination: _destController.text,
                  journeyName: 'Late-Night Commute Home',
                  contactName: _contactNameController.text,
                  contactPhone: _contactPhoneController.text,
                  audio: _audio,
                  motion: _motion,
                  locationTracking: _location,
                );
              },
              icon: const Icon(Icons.shield, color: Colors.black),
              label: const Text(
                'START SAFE JOURNEY',
                style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _presetChip(String label, String value) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.border),
      onPressed: () {
        setState(() {
          _destController.text = value;
        });
      },
    );
  }

  Widget _buildActiveView(BuildContext context, SafetyProvider safety, dynamic journey, dynamic currentPos) {
    final latLng = LatLng(currentPos.latitude, currentPos.longitude);

    return Column(
      children: [
        // Offline / Mesh Status Banner
        if (safety.network.isOffline)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.warning.withValues(alpha: 0.15),
            child: Row(
              children: [
                const Icon(Icons.wifi_off, color: AppColors.warning, size: 16),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'INTERNET UNAVAILABLE — MESH RELAY ACTIVE',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.warning),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.meshIndigo.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.meshIndigo),
                  ),
                  child: const Text('2 Peers in Range', style: TextStyle(fontSize: 10, color: AppColors.meshIndigo)),
                ),
              ],
            ),
          ),

        // Real Map with graceful offline fallback
        Expanded(
          flex: 5,
          child: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: latLng,
                  initialZoom: 15.0,
                ),
                children: [
                  // OpenStreetMap Tile Layer with error fallback
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.maravazha.travel_sos_mesh',
                    errorTileCallback: (tile, error, stackTrace) {
                      // Graceful tile failure handler
                    },
                  ),
                  // Location Marker
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: latLng,
                        width: 44,
                        height: 44,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.cyanAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(color: AppColors.cyanAccent.withValues(alpha: 0.5), blurRadius: 10),
                            ],
                          ),
                          child: const Icon(Icons.navigation, color: Colors.black, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Map GPS Status Pill
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        safety.location.isRealGps ? Icons.gps_fixed : Icons.gps_not_fixed,
                        color: safety.location.isRealGps ? AppColors.success : AppColors.warning,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        safety.location.isRealGps ? 'REAL GPS FIXED' : 'SIMULATED GPS',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Active Telemetry Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        journey.destination,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      Text(
                        'Duration: ${_formatDuration(journey.elapsedSeconds)}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Text(
                      journey.status,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
