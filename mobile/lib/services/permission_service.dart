import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

enum AppPermissionType {
  location,
  microphone,
  notifications,
  bluetooth,
}

enum PermissionUiState {
  granted,
  denied,
  permanentlyDenied,
  unavailable,
}

class PermissionDetail {
  final AppPermissionType type;
  final String title;
  final String description;
  final String whyNeeded;
  final PermissionUiState state;
  final String recoveryInstruction;

  const PermissionDetail({
    required this.type,
    required this.title,
    required this.description,
    required this.whyNeeded,
    required this.state,
    required this.recoveryInstruction,
  });
}

class PermissionService extends ChangeNotifier {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  Map<AppPermissionType, PermissionUiState> _states = {
    AppPermissionType.location: PermissionUiState.denied,
    AppPermissionType.microphone: PermissionUiState.denied,
    AppPermissionType.notifications: PermissionUiState.denied,
    AppPermissionType.bluetooth: PermissionUiState.denied,
  };

  Map<AppPermissionType, PermissionUiState> get states => _states;

  bool get allGranted => _states.values.every((s) => s == PermissionUiState.granted);

  Future<void> checkAllPermissions() async {
    final loc = await _mapStatus(Permission.location);
    final mic = await _mapStatus(Permission.microphone);
    final notif = await _mapStatus(Permission.notification);
    final bt = await _mapStatus(Permission.bluetoothScan);

    _states = {
      AppPermissionType.location: loc,
      AppPermissionType.microphone: mic,
      AppPermissionType.notifications: notif,
      AppPermissionType.bluetooth: bt,
    };

    notifyListeners();
  }

  Future<PermissionUiState> _mapStatus(Permission permission) async {
    try {
      final status = await permission.status;
      if (status.isGranted || status.isLimited) {
        return PermissionUiState.granted;
      } else if (status.isPermanentlyDenied || status.isRestricted) {
        return PermissionUiState.permanentlyDenied;
      } else if (status.isDenied) {
        return PermissionUiState.denied;
      } else {
        return PermissionUiState.unavailable;
      }
    } catch (_) {
      return PermissionUiState.unavailable;
    }
  }

  /// Request specific permission on-demand when the corresponding feature is engaged.
  Future<PermissionUiState> requestPermission(AppPermissionType type) async {
    Permission permission;
    switch (type) {
      case AppPermissionType.location:
        permission = Permission.location;
        break;
      case AppPermissionType.microphone:
        permission = Permission.microphone;
        break;
      case AppPermissionType.notifications:
        permission = Permission.notification;
        break;
      case AppPermissionType.bluetooth:
        // Request bluetooth scan, advertise, and connect for Android 12+
        try {
          await [
            Permission.bluetoothScan,
            Permission.bluetoothAdvertise,
            Permission.bluetoothConnect,
          ].request();
        } catch (_) {}
        permission = Permission.bluetoothScan;
        break;
    }

    try {
      final status = await permission.request();
      PermissionUiState newState;
      if (status.isGranted || status.isLimited) {
        newState = PermissionUiState.granted;
      } else if (status.isPermanentlyDenied || status.isRestricted) {
        newState = PermissionUiState.permanentlyDenied;
      } else if (status.isDenied) {
        newState = PermissionUiState.denied;
      } else {
        newState = PermissionUiState.unavailable;
      }

      _states[type] = newState;
      notifyListeners();
      return newState;
    } catch (_) {
      return PermissionUiState.unavailable;
    }
  }

  Future<bool> openSystemSettings() async {
    return await openAppSettings();
  }

  PermissionDetail getDetail(AppPermissionType type) {
    final state = _states[type] ?? PermissionUiState.denied;
    switch (type) {
      case AppPermissionType.location:
        return PermissionDetail(
          type: type,
          title: 'Location (GPS)',
          description: 'Tracks precise coordinates during journeys for live breadcrumbs and distress beacons.',
          whyNeeded: 'Critical for responders to pinpoint your exact coordinates if an SOS is dispatched.',
          state: state,
          recoveryInstruction: state == PermissionUiState.permanentlyDenied
              ? 'Permanently disabled in Android Settings. Tap "Open App Settings" below to manually enable Location.'
              : 'Tap "Grant Permission" to enable real-time GPS tracking.',
        );
      case AppPermissionType.microphone:
        return PermissionDetail(
          type: type,
          title: 'Microphone (Acoustic Sensor)',
          description: 'Calculates RMS amplitude locally to detect crashes, shattering, or screams.',
          whyNeeded: 'Zero raw audio is ever recorded or uploaded. Only dB level anomalies trigger risk fusion.',
          state: state,
          recoveryInstruction: state == PermissionUiState.permanentlyDenied
              ? 'Microphone blocked in Android Settings. Tap "Open App Settings" to enable local acoustic monitoring.'
              : 'Tap "Grant Permission" to allow on-device acoustic evaluation.',
        );
      case AppPermissionType.notifications:
        return PermissionDetail(
          type: type,
          title: 'Notifications & Alerts',
          description: 'Delivers high-priority warnings during safety challenges and responder updates.',
          whyNeeded: 'Ensures you hear and see the 10-second false-positive challenge even if your phone is locked.',
          state: state,
          recoveryInstruction: state == PermissionUiState.permanentlyDenied
              ? 'Notifications silenced in Android Settings. Tap "Open App Settings" to enable critical safety alerts.'
              : 'Tap "Grant Permission" to receive emergency countdown notifications.',
        );
      case AppPermissionType.bluetooth:
        return PermissionDetail(
          type: type,
          title: 'Bluetooth (Mesh Relay)',
          description: 'Scans and broadcasts encrypted distress packets to nearby peer devices when offline.',
          whyNeeded: 'Enables store-and-forward mesh hopping when cellular reception is completely unavailable.',
          state: state,
          recoveryInstruction: state == PermissionUiState.permanentlyDenied
              ? 'Nearby device scanning disabled in Android Settings. Tap "Open App Settings" to enable BLE mesh.'
              : 'Tap "Grant Permission" to participate in the offline emergency mesh.',
        );
    }
  }
}
