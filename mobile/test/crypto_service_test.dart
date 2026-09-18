import 'package:flutter_test/flutter_test.dart';
import 'package:travel_sos_mesh/services/crypto_service.dart';

void main() {
  group('CryptoService Practical Security Architecture (Phase 27)', () {
    late CryptoService crypto;

    setUp(() {
      crypto = CryptoService();
    });

    test('Generates consistent origin device ID', () {
      final id1 = crypto.deviceId;
      final id2 = crypto.deviceId;
      expect(id1, startsWith('ANDROID-DEV-'));
      expect(id1, equals(id2));
    });

    test('Seals cleartext JSON payload into AES-GCM-256 envelope', () {
      final data = {
        'incidentId': 'INC-1234',
        'latitude': 9.9312,
        'longitude': 76.2673,
        'battery': 85,
      };

      final envelope = crypto.sealPayload(data);
      expect(envelope.algorithm, equals('AES-GCM-256'));
      expect(envelope.ivHex.length, equals(24));
      expect(envelope.tagHex.length, equals(32));
      expect(envelope.ciphertextHex, isNotEmpty);
      expect(envelope.fullString, startsWith('AES-GCM-256:'));
    });

    test('Generates Ed25519 digital signature representation', () {
      final sig = crypto.signMessage('SOS-001', 'TAG12345');
      expect(sig, startsWith('ED25519-SIG:'));
      expect(sig, contains(crypto.deviceId));
    });

    test('Computes tamper-evident rolling event hash', () {
      final h1 = crypto.computeEventHash('GENESIS', 'EVT-1', 'Danger Detected', 1000);
      final h2 = crypto.computeEventHash(h1, 'EVT-2', 'Challenge Active', 1010);
      expect(h1, isNotEmpty);
      expect(h2, isNotEmpty);
      expect(h1, isNot(equals(h2)));
    });
  });
}
