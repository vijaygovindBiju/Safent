import 'package:flutter_test/flutter_test.dart';
import 'package:travel_sos_mesh/services/ble_service.dart';

void main() {
  group('BLE 31-Byte Emergency Beacon PDU Framing (Phase 20)', () {
    late BleService bleService;

    setUp(() {
      bleService = BleService();
    });

    test('Serializes and deserializes 31-byte distress beacon payload accurately', () {
      const messageId = 'SOS-PKT-TEST1234';
      const latitude = 9.93123;
      const longitude = 76.26732;
      const accuracy = 12.0;
      const battery = 84;
      const riskScore = 95;
      const hopCount = 1;

      final packet = bleService.serialize31ByteBeacon(
        messageId: messageId,
        latitude: latitude,
        longitude: longitude,
        accuracy: accuracy,
        battery: battery,
        riskScore: riskScore,
        hopCount: hopCount,
      );

      expect(packet.length, equals(31));
      expect(packet[0], equals(0x1E)); // 30 bytes length
      expect(packet[1], equals(0x16)); // 16-bit Service Data AD type

      final parsed = bleService.deserialize31ByteBeacon(packet);
      expect(parsed.serviceUuid, equals(0xFEE4));
      expect(parsed.latitude, closeTo(latitude, 0.0001));
      expect(parsed.longitude, closeTo(longitude, 0.0001));
      expect(parsed.accuracyMeters, equals(12));
      expect(parsed.batteryPercent, equals(84));
      expect(parsed.riskScore, equals(95));
      expect(parsed.hopCount, equals(1));
      expect(parsed.checksum, isNonZero);
    });

    test('Starts and stops broadcasting state correctly', () {
      expect(bleService.state, equals(BleBroadcastState.idle));

      bleService.startBroadcastingSOS(
        messageId: 'SOS-001',
        latitude: 9.93,
        longitude: 76.26,
        accuracy: 10,
        battery: 90,
        riskScore: 92,
        hopCount: 0,
      );

      expect(bleService.state, equals(BleBroadcastState.advertising));
      expect(bleService.lastAdvertisedPacket, isNotNull);
      expect(bleService.lastHexDump, isNotEmpty);

      bleService.stopBroadcasting();
      expect(bleService.state, equals(BleBroadcastState.idle));
    });
  });
}
