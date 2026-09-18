import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum AppNetworkStatus { online, offline, unknown }

class NetworkService extends ChangeNotifier {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isManualOfflineOverride = false;
  AppNetworkStatus _realStatus = AppNetworkStatus.unknown;

  bool get isManualOffline => _isManualOfflineOverride;

  AppNetworkStatus get currentStatus {
    if (_isManualOfflineOverride) return AppNetworkStatus.offline;
    return _realStatus;
  }

  bool get isOnline => currentStatus == AppNetworkStatus.online;
  bool get isOffline => currentStatus == AppNetworkStatus.offline;

  Future<void> init() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _updateStatus(results);
    });
  }

  void _updateStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet)) {
      _realStatus = AppNetworkStatus.online;
    } else if (results.contains(ConnectivityResult.none)) {
      _realStatus = AppNetworkStatus.offline;
    } else {
      _realStatus = AppNetworkStatus.unknown;
    }
    notifyListeners();
  }

  void toggleManualOffline() {
    _isManualOfflineOverride = !_isManualOfflineOverride;
    notifyListeners();
  }

  void setManualOffline(bool offline) {
    _isManualOfflineOverride = offline;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
