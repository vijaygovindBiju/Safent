import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../core/constants/app_colors.dart';
import '../models/journey.dart';
import '../providers/safety_provider.dart';
import '../services/permission_service.dart';
import '../services/storage_service.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  final _destController = TextEditingController(text: 'MG Road Metro Station, Kochi');
  final _journeyNameController = TextEditingController(text: 'Late-Night Transit Home');
  final _contactNameController = TextEditingController(text: 'Anjali Menon (Sister)');
  final _contactPhoneController = TextEditingController(text: '+91 98470 12345');

  bool _audio = true;
  bool _motion = true;
  bool _location = true;
  int _expectedMinutes = 30;

  @override
  void initState() {
    super.initState();
    _loadSavedContact();
  }

  Future<void> _loadSavedContact() async {
    final contact = await StorageService().loadTrustedContact();
    if (contact != null && mounted) {
      setState(() {
        _contactNameController.text = contact.name;
        _contactPhoneController.text = contact.phone;
      });
    }
  }

  @override
  void dispose() {
    _destController.dispose();
    _journeyNameController.dispose();
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
          // Section 1: Journey Details
          const Text(
            'JOURNEY IDENTIFICATION',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _journeyNameController,
            decoration: InputDecoration(
              labelText: 'Journey Name',
              prefixIcon: const Icon(Icons.drive_file_rename_outline, color: AppColors.cyanAccent),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            children: [
              _journeyPresetChip('Transit Home', 'Late-Night Transit Home'),
              _journeyPresetChip('Campus Commute', 'CUSAT Campus Shuttle'),
              _journeyPresetChip('Night Cab', 'Ola/Uber Late Ride'),
            ],
          ),

          const SizedBox(height: 18),

          // Section 2: Destination
          const Text(
            'DESTINATION & ROUTE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _destController,
            decoration: InputDecoration(
              labelText: 'Destination Landmark / Address',
              prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.cyanAccent),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _presetChip('Home (Panampilly)', 'Home (Panampilly Nagar, Kochi)'),
              _presetChip('College (CUSAT)', 'CUSAT Campus, Kalamassery'),
              _presetChip('Kochi (MG Road)', 'MG Road Metro Station, Kochi'),
              _presetChip('Airport (COK)', 'Cochin International Airport (COK)'),
              _presetChip('InfoPark', 'InfoPark Expressway, Kakkanad'),
            ],
          ),

          const SizedBox(height: 18),

          // Section 3: Expected Arrival Time
          const Text(
            'EXPECTED ARRIVAL DURATION',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [15, 30, 45, 60].map((mins) {
              final isSelected = _expectedMinutes == mins;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text('${mins}m'),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    onSelected: (_) => setState(() => _expectedMinutes = mins),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          // Section 4: Trusted Emergency Contact
          const Text(
            'EMERGENCY TRUSTED CONTACT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),

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

          // Section 5: Monitoring Sensors
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

          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Audio Anomaly Detection', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Local acoustic scream & shatter evaluation', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  value: _audio,
                  activeThumbColor: AppColors.cyanAccent,
                  onChanged: (val) => setState(() => _audio = val),
                ),
                const Divider(height: 1, color: AppColors.border),
                SwitchListTile(
                  title: const Text('Motion / Impact Detection', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('3-axis Accelerometer & Gyroscope monitoring', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  value: _motion,
                  activeThumbColor: AppColors.cyanAccent,
                  onChanged: (val) => setState(() => _motion = val),
                ),
                const Divider(height: 1, color: AppColors.border),
                SwitchListTile(
                  title: const Text('GPS Location Breadcrumbs', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Adaptive battery-efficient location tracking', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  value: _location,
                  activeThumbColor: AppColors.cyanAccent,
                  onChanged: (val) => setState(() => _location = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Start Button
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

                // Save trusted contact locally
                await StorageService().saveTrustedContact(
                  TrustedContact(
                    name: _contactNameController.text,
                    phone: _contactPhoneController.text,
                  ),
                );

                await safety.startJourney(
                  destination: _destController.text,
                  journeyName: _journeyNameController.text,
                  contactName: _contactNameController.text,
                  contactPhone: _contactPhoneController.text,
                  audio: _audio,
                  motion: _motion,
                  locationTracking: _location,
                  expectedMinutes: _expectedMinutes,
                );
              },
              icon: const Icon(Icons.shield_rounded, color: Colors.black),
              label: const Text(
                'START SAFE JOURNEY',
                style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 0.5),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 20),
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

  Widget _journeyPresetChip(String label, String value) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.border),
      onPressed: () {
        setState(() {
          _journeyNameController.text = value;
        });
      },
    );
  }

  LatLng _resolveDestinationLatLng(String destName, LocationPoint currentPos) {
    final lower = destName.toLowerCase();
    if (lower.contains('home') || lower.contains('panampilly')) {
      return const LatLng(9.9575, 76.2995);
    } else if (lower.contains('cusat') || lower.contains('college')) {
      return const LatLng(10.0435, 76.3242);
    } else if (lower.contains('airport') || lower.contains('cok')) {
      return const LatLng(10.1518, 76.3930);
    } else if (lower.contains('infopark') || lower.contains('kakkanad')) {
      return const LatLng(10.0104, 76.3638);
    } else if (lower.contains('marine drive')) {
      return const LatLng(9.9816, 76.2754);
    } else if (lower.contains('mg road')) {
      return const LatLng(9.9726, 76.2798);
    }
    return LatLng(currentPos.latitude + 0.018, currentPos.longitude + 0.014);
  }

  Widget _buildActiveView(
    BuildContext context,
    SafetyProvider safety,
    Journey journey,
    LocationPoint currentPos,
  ) {
    final latLng = LatLng(currentPos.latitude, currentPos.longitude);
    final destLatLng = _resolveDestinationLatLng(journey.destination, currentPos);
    final relayLatLng = LatLng(currentPos.latitude + 0.0015, currentPos.longitude - 0.0012);

    final distMeters = Geolocator.distanceBetween(
      currentPos.latitude,
      currentPos.longitude,
      destLatLng.latitude,
      destLatLng.longitude,
    );
    final distText = distMeters >= 1000
        ? '${(distMeters / 1000).toStringAsFixed(1)} km'
        : '${distMeters.toStringAsFixed(0)} m';

    final breadcrumbs = journey.breadcrumbs.isNotEmpty
        ? journey.breadcrumbs.map((p) => LatLng(p.latitude, p.longitude)).toList()
        : [latLng];

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
                      // Graceful tile failure handler - dark canvas persists
                    },
                  ),

                  // GPS Accuracy Radius Circle
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: latLng,
                        radius: currentPos.accuracy.clamp(8.0, 150.0),
                        useRadiusInMeter: true,
                        color: AppColors.cyanAccent.withValues(alpha: 0.12),
                        borderColor: AppColors.cyanAccent.withValues(alpha: 0.4),
                        borderStrokeWidth: 1.5,
                      ),
                    ],
                  ),

                  // Breadcrumb Trail Polyline
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: breadcrumbs,
                        color: AppColors.cyanAccent,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),

                  // Map Markers: Destination, Relay Node B, Current Location
                  MarkerLayer(
                    markers: [
                      // 1. Destination Marker
                      Marker(
                        point: destLatLng,
                        width: 110,
                        height: 60,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.emergency),
                              ),
                              child: Text(
                                journey.destination.split(',').first,
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.flag_rounded, color: AppColors.emergency, size: 24),
                          ],
                        ),
                      ),

                      // 2. Nearby Mesh Relay Peer (Node B)
                      Marker(
                        point: relayLatLng,
                        width: 90,
                        height: 52,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.meshIndigo.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Relay Phone B',
                                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                            ),
                            const Icon(Icons.hub_rounded, color: AppColors.meshIndigo, size: 20),
                          ],
                        ),
                      ),

                      // 3. Current Location Marker with Heading Arrow
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
                          child: Transform.rotate(
                            angle: (currentPos.heading * pi / 180),
                            child: const Icon(Icons.navigation, color: Colors.black, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Map GPS Status & Navigation Pill
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // GPS Accuracy Pill
                    Container(
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
                            safety.location.isRealGps
                                ? 'GPS: ±${currentPos.accuracy.toStringAsFixed(1)}m'
                                : 'SIMULATED GPS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: safety.location.isRealGps ? AppColors.success : AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Distance & Heading Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.near_me_rounded, color: AppColors.cyanAccent, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            distText,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${currentPos.heading.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // OpenStreetMap Attribution (Step 19)
              Positioned(
                bottom: 6,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '© OpenStreetMap contributors',
                    style: TextStyle(fontSize: 8, color: AppColors.textMuted),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Journey Telemetry Card
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
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      Text(
                        '${journey.journeyName} • ${journey.expectedArrivalMinutes}m Target • ID: ${journey.id}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
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
              const SizedBox(height: 12),

              // End Journey / Trigger Danger Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        safety.resetDemo();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textMuted,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('END JOURNEY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        safety.triggerDangerDetected(isSimulated: true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emergency,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'SIMULATE DANGER',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
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
