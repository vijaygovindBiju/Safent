import 'package:flutter/foundation.dart';
import '../models/mesh_node.dart';
import '../models/sos_message.dart';

class MeshService extends ChangeNotifier {
  static final MeshService _instance = MeshService._internal();
  factory MeshService() => _instance;
  MeshService._internal();

  final Set<String> _seenMessageIds = {};
  int _currentHopIndex = 0;
  SOSMessage? _activeMessage;

  int get currentHopIndex => _currentHopIndex;
  SOSMessage? get activeMessage => _activeMessage;

  List<MeshNode> _nodes = [
    MeshNode(
      id: 'NODE_A',
      name: 'Traveller Phone A',
      type: 'TRAVELLER',
      roleDescription: 'Origin Device (Late-Night Traveller)',
      networkStatus: 'NO_INTERNET',
      protocol: 'BLE_5.2_EXT_ADV',
      identifier: 'F4:B8:5E:21:0A:7D',
      hasPayload: true,
      isCurrentHop: true,
    ),
    MeshNode(
      id: 'NODE_B',
      name: 'Relay Phone B',
      type: 'RELAY',
      roleDescription: 'Nearby Commuter in Auto-Rickshaw (35m)',
      networkStatus: 'BLUETOOTH_MESH_ONLY',
      protocol: 'BLE_5.2_EXT_ADV',
      identifier: 'A8:C2:1B:90:5E:44',
    ),
    MeshNode(
      id: 'NODE_C',
      name: 'Gateway Phone C',
      type: 'GATEWAY',
      roleDescription: 'Pedestrian with 5G Internet Reception',
      networkStatus: 'INTERNET_ACTIVE',
      protocol: 'WIFI_AWARE',
      identifier: '3C:D9:2F:81:4A:E0',
    ),
    MeshNode(
      id: 'NODE_CLOUD',
      name: 'Cloud SOS Backend',
      type: 'BACKEND',
      roleDescription: 'Central Emergency Ingest Cluster',
      networkStatus: 'CLOUD_INGEST',
      protocol: 'HTTPS_REST',
      identifier: 'sos.mesh.kerala.gov.in',
    ),
    MeshNode(
      id: 'NODE_RESPONDER',
      name: 'Safety Response Center',
      type: 'RESPONDER',
      roleDescription: 'Emergency Dispatch Console #04',
      networkStatus: 'DISPATCH_CENTER',
      protocol: 'WEBSOCKET_PUSH',
      identifier: 'DISPATCH_DESK_04',
    ),
  ];

  List<MeshNode> get nodes => _nodes;

  void initializeWithSOS(SOSMessage message) {
    _activeMessage = message;
    _currentHopIndex = 0;
    _seenMessageIds.add(message.messageId);

    _nodes = _nodes.map((n) {
      final isFirst = n.id == 'NODE_A';
      n.hasPayload = isFirst;
      n.isCurrentHop = isFirst;
      n.isDelivered = false;
      return n;
    }).toList();

    notifyListeners();
  }

  void advanceHop() {
    if (_activeMessage == null || _currentHopIndex >= 4) return;

    _currentHopIndex++;
    final nextHop = _currentHopIndex;

    _nodes = _nodes.asMap().entries.map((entry) {
      final idx = entry.key;
      final node = entry.value;
      node.hasPayload = idx <= nextHop;
      node.isCurrentHop = idx == nextHop;
      node.isDelivered = nextHop >= 4;
      return node;
    }).toList();

    _activeMessage!.hopCount = nextHop;
    _activeMessage!.ttl = (_activeMessage!.ttl - 1).clamp(0, 300);

    String status = 'RELAYING';
    if (nextHop == 2) status = 'UPLOADING';
    if (nextHop >= 3) status = 'DELIVERED';
    _activeMessage!.status = status;

    notifyListeners();
  }

  void reset() {
    _currentHopIndex = 0;
    _activeMessage = null;
    _seenMessageIds.clear();

    _nodes = _nodes.map((n) {
      n.hasPayload = false;
      n.isCurrentHop = false;
      n.isDelivered = false;
      return n;
    }).toList();

    notifyListeners();
  }
}
