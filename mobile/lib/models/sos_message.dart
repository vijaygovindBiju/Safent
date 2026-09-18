import 'dart:convert';

class RouteHop {
  final String nodeId;
  final String nodeName;
  final DateTime timestamp;
  final int hopIndex;
  final String protocol;
  final int latencyMs;
  final String actionTaken;

  RouteHop({
    required this.nodeId,
    required this.nodeName,
    DateTime? timestamp,
    required this.hopIndex,
    required this.protocol,
    this.latencyMs = 0,
    required this.actionTaken,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'nodeId': nodeId,
      'nodeName': nodeName,
      'timestamp': timestamp.toIso8601String(),
      'hopIndex': hopIndex,
      'protocol': protocol,
      'latencyMs': latencyMs,
      'actionTaken': actionTaken,
    };
  }

  factory RouteHop.fromMap(Map<String, dynamic> map) {
    return RouteHop(
      nodeId: map['nodeId'] ?? '',
      nodeName: map['nodeName'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      hopIndex: map['hopIndex'] ?? 0,
      protocol: map['protocol'] ?? 'BLE_5.2',
      latencyMs: map['latencyMs'] ?? 0,
      actionTaken: map['actionTaken'] ?? '',
    );
  }
}

class SOSMessage {
  final String messageId;
  final String incidentId;
  final String originDeviceId;
  String currentNodeId;
  int hopCount;
  final int maxHops;
  int ttl; // Seconds remaining
  final DateTime timestamp;
  String status; // 'QUEUED', 'RELAYING', 'UPLOADING', 'DELIVERED', 'FAILED'
  final String encryptedPayload;
  final String signature;
  final bool isSimulated;
  List<RouteHop> routeHistory;

  SOSMessage({
    required this.messageId,
    required this.incidentId,
    required this.originDeviceId,
    required this.currentNodeId,
    this.hopCount = 0,
    this.maxHops = 5,
    this.ttl = 300,
    DateTime? timestamp,
    this.status = 'QUEUED',
    required this.encryptedPayload,
    required this.signature,
    this.isSimulated = false,
    List<RouteHop>? routeHistory,
  })  : timestamp = timestamp ?? DateTime.now(),
        routeHistory = routeHistory ?? [];

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'incidentId': incidentId,
      'originDeviceId': originDeviceId,
      'currentNodeId': currentNodeId,
      'hopCount': hopCount,
      'maxHops': maxHops,
      'ttl': ttl,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'encryptedPayload': encryptedPayload,
      'signature': signature,
      'isSimulated': isSimulated,
      'routeHistory': routeHistory.map((h) => h.toMap()).toList(),
    };
  }

  factory SOSMessage.fromMap(Map<String, dynamic> map) {
    return SOSMessage(
      messageId: map['messageId'],
      incidentId: map['incidentId'],
      originDeviceId: map['originDeviceId'] ?? 'ANDROID_NODE_A',
      currentNodeId: map['currentNodeId'] ?? 'NODE_A',
      hopCount: map['hopCount'] ?? 0,
      maxHops: map['maxHops'] ?? 5,
      ttl: map['ttl'] ?? 300,
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      status: map['status'] ?? 'QUEUED',
      encryptedPayload: map['encryptedPayload'] ?? '',
      signature: map['signature'] ?? '',
      isSimulated: map['isSimulated'] ?? false,
      routeHistory: (map['routeHistory'] as List<dynamic>?)
              ?.map((h) => RouteHop.fromMap(h))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());
  factory SOSMessage.fromJson(String source) => SOSMessage.fromMap(json.decode(source));
}
