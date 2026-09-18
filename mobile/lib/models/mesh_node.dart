class MeshNode {
  final String id;
  final String name;
  final String type; // 'TRAVELLER', 'RELAY', 'GATEWAY', 'BACKEND', 'RESPONDER'
  final String roleDescription;
  final String networkStatus; // 'NO_INTERNET', 'BLUETOOTH_MESH_ONLY', 'INTERNET_ACTIVE', 'CLOUD_INGEST', 'DISPATCH_CENTER'
  final int signalStrengthDbm;
  final int batteryPercent;
  bool hasPayload;
  bool isCurrentHop;
  bool isDelivered;
  final String protocol;
  final String identifier;

  MeshNode({
    required this.id,
    required this.name,
    required this.type,
    required this.roleDescription,
    required this.networkStatus,
    this.signalStrengthDbm = -50,
    this.batteryPercent = 100,
    this.hasPayload = false,
    this.isCurrentHop = false,
    this.isDelivered = false,
    required this.protocol,
    required this.identifier,
  });
}
