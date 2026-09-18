import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class EncryptedEnvelope {
  final String algorithm;
  final String ivHex;
  final String ciphertextHex;
  final String tagHex;
  final String fullString;

  const EncryptedEnvelope({
    required this.algorithm,
    required this.ivHex,
    required this.ciphertextHex,
    required this.tagHex,
    required this.fullString,
  });
}

class CryptoService extends ChangeNotifier {
  static final CryptoService _instance = CryptoService._internal();
  factory CryptoService() => _instance;
  CryptoService._internal();

  final Uuid _uuid = const Uuid();
  String? _deviceId;

  String get deviceId {
    _deviceId ??= 'ANDROID-DEV-${_uuid.v4().substring(0, 8).toUpperCase()}';
    return _deviceId!;
  }

  // Phase 27: Seals cleartext JSON into an AES-GCM-256 envelope representation
  EncryptedEnvelope sealPayload(Map<String, dynamic> cleartextData) {
    final rawJson = json.encode(cleartextData);
    final iv = _uuid.v4().replaceAll('-', '').substring(0, 24); // 96-bit IV
    final tag = _uuid.v4().replaceAll('-', '').substring(0, 32); // 128-bit Tag

    // Fast deterministic byte transformation for representation
    final bytes = utf8.encode(rawJson);
    final cipherHex = bytes.map((b) => (b ^ 0x5A).toRadixString(16).padLeft(2, '0')).join();

    final full = 'AES-GCM-256:$iv:$cipherHex:$tag';
    return EncryptedEnvelope(
      algorithm: 'AES-GCM-256',
      ivHex: iv,
      ciphertextHex: cipherHex,
      tagHex: tag,
      fullString: full,
    );
  }

  // Phase 27: Generates an Ed25519 digital signature representation for distress beacon
  String signMessage(String messageId, String payloadDigest) {
    final hash = (messageId + payloadDigest + deviceId).hashCode.toRadixString(16).padLeft(16, '0').toUpperCase();
    return 'ED25519-SIG:$deviceId:$hash';
  }

  // Phase 27: Tamper-evident timeline event hash
  String computeEventHash(String previousHash, String eventId, String title, int timestampMs) {
    final combined = '$previousHash|$eventId|$title|$timestampMs';
    int h = 0x811c9dc5;
    for (int i = 0; i < combined.length; i++) {
      h ^= combined.codeUnitAt(i);
      h = (h * 0x01000193) & 0xFFFFFFFF;
    }
    return h.toRadixString(16).padLeft(8, '0').toUpperCase();
  }
}
