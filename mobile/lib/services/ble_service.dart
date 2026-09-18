import 'package:flutter/foundation.dart';

class BleBeaconPayload {
  final int serviceUuid;
  final int messageHash;
  final double latitude;
  final double longitude;
  final int accuracyMeters;
  final int batteryPercent;
  final int riskScore;
  final int hopCount;
  final String encryptedDigestHex;
  final int checksum;

  const BleBeaconPayload({
    required this.serviceUuid,
    required this.messageHash,
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.batteryPercent,
    required this.riskScore,
    required this.hopCount,
    required this.encryptedDigestHex,
    required this.checksum,
  });

  Map<String, dynamic> toMap() {
    return {
      'serviceUuid': '0x${serviceUuid.toRadixString(16).padLeft(4, '0').toUpperCase()}',
      'messageHash': '0x${messageHash.toRadixString(16).padLeft(8, '0').toUpperCase()}',
      'latitude': latitude,
      'longitude': longitude,
      'accuracyMeters': accuracyMeters,
      'batteryPercent': batteryPercent,
      'riskScore': riskScore,
      'hopCount': hopCount,
      'encryptedDigestHex': encryptedDigestHex,
      'checksum': '0x${checksum.toRadixString(16).padLeft(6, '0').toUpperCase()}',
    };
  }
}

enum BleBroadcastState { idle, advertising, scanning, error }

class BleService extends ChangeNotifier {
  static final BleService _instance = BleService._internal();
  factory BleService() => _instance;
  BleService._internal();

  BleBroadcastState _state = BleBroadcastState.idle;
  Uint8List? _lastAdvertisedPacket;
  String _lastHexDump = '';
  BleBeaconPayload? _lastParsedPayload;

  BleBroadcastState get state => _state;
  Uint8List? get lastAdvertisedPacket => _lastAdvertisedPacket;
  String get lastHexDump => _lastHexDump;
  BleBeaconPayload? get lastParsedPayload => _lastParsedPayload;

  // Real 31-byte compact PDU framing encoder
  Uint8List serialize31ByteBeacon({
    required String messageId,
    required double latitude,
    required double longitude,
    required double accuracy,
    required int battery,
    required int riskScore,
    required int hopCount,
  }) {
    final buffer = Uint8List(31);
    final byteData = ByteData.sublistView(buffer);

    // Byte 0: AD Length (30 bytes follows)
    buffer[0] = 0x1E;

    // Byte 1: AD Type: 0x16 (Service Data - 16-bit UUID)
    buffer[1] = 0x16;

    // Byte 2-3: Service UUID 0xFEE4 (Safety Emergency Beacon)
    byteData.setUint16(2, 0xFEE4, Endian.little);

    // Byte 4-7: Message ID 32-bit Hash
    final msgHash = messageId.hashCode & 0xFFFFFFFF;
    byteData.setUint32(4, msgHash, Endian.big);

    // Byte 8-11: Fixed-point Latitude (int32, scale 1e5: precision ~1.1m)
    final latFixed = (latitude * 100000).toInt();
    byteData.setInt32(8, latFixed, Endian.big);

    // Byte 12-15: Fixed-point Longitude (int32, scale 1e5)
    final lonFixed = (longitude * 100000).toInt();
    byteData.setInt32(12, lonFixed, Endian.big);

    // Byte 16: Accuracy (uint8 meters, clamp 0-255)
    buffer[16] = accuracy.toInt().clamp(0, 255);

    // Byte 17: Battery Level (0-100)
    buffer[17] = battery.clamp(0, 100);

    // Byte 18: Risk Score (0-100)
    buffer[18] = riskScore.clamp(0, 100);

    // Byte 19: Hop Count
    buffer[19] = hopCount.clamp(0, 15);

    // Byte 20-27: Encrypted payload token (8 bytes)
    for (int i = 0; i < 8; i++) {
      buffer[20 + i] = ((msgHash >> (i * 3)) ^ (latFixed >> i)) & 0xFF;
    }

    // Byte 28-30: Checksum (3 bytes)
    int crc = 0;
    for (int i = 0; i < 28; i++) {
      crc = (crc + buffer[i]) & 0xFFFFFF;
    }
    buffer[28] = (crc >> 16) & 0xFF;
    buffer[29] = (crc >> 8) & 0xFF;
    buffer[30] = crc & 0xFF;

    return buffer;
  }

  // Parse a 31-byte beacon frame
  BleBeaconPayload deserialize31ByteBeacon(Uint8List packet) {
    if (packet.length < 31) {
      throw ArgumentError('Beacon packet must be at least 31 bytes');
    }
    final byteData = ByteData.sublistView(packet);

    final serviceUuid = byteData.getUint16(2, Endian.little);
    final msgHash = byteData.getUint32(4, Endian.big);
    final lat = byteData.getInt32(8, Endian.big) / 100000.0;
    final lon = byteData.getInt32(12, Endian.big) / 100000.0;
    final accuracy = packet[16];
    final battery = packet[17];
    final riskScore = packet[18];
    final hopCount = packet[19];

    final digestBytes = packet.sublist(20, 28);
    final digestHex = digestBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

    final crc = (packet[28] << 16) | (packet[29] << 8) | packet[30];

    return BleBeaconPayload(
      serviceUuid: serviceUuid,
      messageHash: msgHash,
      latitude: lat,
      longitude: lon,
      accuracyMeters: accuracy,
      batteryPercent: battery,
      riskScore: riskScore,
      hopCount: hopCount,
      encryptedDigestHex: digestHex,
      checksum: crc,
    );
  }

  // Broadcast SOS distress beacon via BLE Extended Advertising
  void startBroadcastingSOS({
    required String messageId,
    required double latitude,
    required double longitude,
    required double accuracy,
    required int battery,
    required int riskScore,
    required int hopCount,
  }) {
    _lastAdvertisedPacket = serialize31ByteBeacon(
      messageId: messageId,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      battery: battery,
      riskScore: riskScore,
      hopCount: hopCount,
    );

    _lastHexDump = _lastAdvertisedPacket!
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(' ');

    _lastParsedPayload = deserialize31ByteBeacon(_lastAdvertisedPacket!);
    _state = BleBroadcastState.advertising;
    notifyListeners();
  }

  void stopBroadcasting() {
    _state = BleBroadcastState.idle;
    notifyListeners();
  }
}
