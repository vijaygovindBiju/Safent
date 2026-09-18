import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/journey.dart';
import '../models/incident.dart';
import '../models/sos_message.dart';

class BackendResult {
  final bool isSuccess;
  final int statusCode;
  final String message;
  final dynamic data;

  const BackendResult({
    required this.isSuccess,
    required this.statusCode,
    required this.message,
    this.data,
  });
}

class BackendService extends ChangeNotifier {
  static final BackendService _instance = BackendService._internal();
  factory BackendService() => _instance;
  BackendService._internal();

  // Android emulator loopback: 10.0.2.2, Localhost: 127.0.0.1
  String _baseUrl = 'http://10.0.2.2:3000';
  bool _isServerReachable = false;
  DateTime? _lastHealthCheck;

  bool get isServerReachable => _isServerReachable;
  DateTime? get lastHealthCheck => _lastHealthCheck;
  String get baseUrl => _baseUrl;

  void setBaseUrl(String url) {
    _baseUrl = url;
    notifyListeners();
  }

  // Check health of cloud ingest backend
  Future<bool> checkHealth() async {
    try {
      final uri = Uri.parse('$_baseUrl/api/health');
      final response = await http.get(uri).timeout(const Duration(seconds: 3));
      _isServerReachable = response.statusCode == 200;
      _lastHealthCheck = DateTime.now();
      notifyListeners();
      return _isServerReachable;
    } catch (_) {
      _isServerReachable = false;
      _lastHealthCheck = DateTime.now();
      notifyListeners();
      return false;
    }
  }

  // Register Journey to Cloud Safety Monitor
  Future<BackendResult> registerJourney(Journey journey) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/journeys');
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(journey.toMap()),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BackendResult(
          isSuccess: true,
          statusCode: response.statusCode,
          message: 'Journey registered on cloud safety monitor',
          data: json.decode(response.body),
        );
      }
      return BackendResult(
        isSuccess: false,
        statusCode: response.statusCode,
        message: 'Server rejected journey: ${response.statusCode}',
      );
    } catch (e) {
      return BackendResult(
        isSuccess: false,
        statusCode: 0,
        message: 'Offline / Server unreachable: $e',
      );
    }
  }

  // Dispatch Emergency SOS distress beacon
  Future<BackendResult> dispatchSOS(SOSMessage message, Incident incident) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/incidents');
      final payload = {
        'id': incident.id,
        'journeyId': incident.journeyId,
        'messageId': message.messageId,
        'type': incident.type,
        'riskScore': incident.riskScore,
        'location': incident.location.toMap(),
        'battery': incident.battery,
        'travellerName': incident.travellerName,
        'encryptedPayload': message.encryptedPayload,
        'signature': message.signature,
        'hopCount': message.hopCount,
        'routeHistory': message.routeHistory.map((h) => h.toMap()).toList(),
        'status': 'SOS_INGESTED',
      };

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(payload),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BackendResult(
          isSuccess: true,
          statusCode: response.statusCode,
          message: 'Distress beacon ingested into emergency dispatch queue',
          data: json.decode(response.body),
        );
      }
      return BackendResult(
        isSuccess: false,
        statusCode: response.statusCode,
        message: 'Server error on SOS ingestion: ${response.statusCode}',
      );
    } catch (e) {
      return BackendResult(
        isSuccess: false,
        statusCode: 0,
        message: 'Offline / Queued locally: $e',
      );
    }
  }

  // Responder Acknowledge
  Future<BackendResult> acknowledgeIncident(String incidentId, String responderName) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/incidents/$incidentId/acknowledge');
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'responder': responderName,
              'notes': 'Emergency units dispatched to verified coordinates.',
            }),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        return BackendResult(
          isSuccess: true,
          statusCode: 200,
          message: 'Incident acknowledged by emergency response console',
          data: json.decode(response.body),
        );
      }
      return BackendResult(
        isSuccess: false,
        statusCode: response.statusCode,
        message: 'Failed to acknowledge: ${response.statusCode}',
      );
    } catch (e) {
      return BackendResult(
        isSuccess: false,
        statusCode: 0,
        message: 'Network offline: $e',
      );
    }
  }

  // Responder Resolve
  Future<BackendResult> resolveIncident(String incidentId) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/incidents/$incidentId/resolve');
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'notes': 'Scene secured. Traveller confirmed safe.',
            }),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        return BackendResult(
          isSuccess: true,
          statusCode: 200,
          message: 'Incident resolved successfully',
          data: json.decode(response.body),
        );
      }
      return BackendResult(
        isSuccess: false,
        statusCode: response.statusCode,
        message: 'Failed to resolve: ${response.statusCode}',
      );
    } catch (e) {
      return BackendResult(
        isSuccess: false,
        statusCode: 0,
        message: 'Network offline: $e',
      );
    }
  }
}
