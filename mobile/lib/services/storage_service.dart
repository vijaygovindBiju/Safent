import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journey.dart';
import '../models/incident.dart';
import '../models/sos_message.dart';

class StorageService {
  static const String _keyActiveJourney = 'travel_sos_active_journey';
  static const String _keyIncidents = 'travel_sos_incidents';
  static const String _keyPendingSos = 'travel_sos_pending_messages';
  static const String _keyTrustedContact = 'travel_sos_trusted_contact';

  // Singleton instance
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // --- Journey Storage ---
  Future<void> saveActiveJourney(Journey? journey) async {
    await init();
    if (journey == null) {
      await _prefs!.remove(_keyActiveJourney);
    } else {
      await _prefs!.setString(_keyActiveJourney, journey.toJson());
    }
  }

  Future<Journey?> loadActiveJourney() async {
    await init();
    final jsonStr = _prefs!.getString(_keyActiveJourney);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      return Journey.fromJson(jsonStr);
    } catch (_) {
      return null;
    }
  }

  // --- Incidents Storage ---
  Future<void> saveIncidents(List<Incident> incidents) async {
    await init();
    final list = incidents.map((i) => i.toJson()).toList();
    await _prefs!.setStringList(_keyIncidents, list);
  }

  Future<List<Incident>> loadIncidents() async {
    await init();
    final list = _prefs!.getStringList(_keyIncidents);
    if (list == null) return [];
    final result = <Incident>[];
    for (final str in list) {
      try {
        result.add(Incident.fromJson(str));
      } catch (_) {}
    }
    return result;
  }

  // --- Offline SOS Queue (Survives App Restarts) ---
  Future<void> savePendingSosQueue(List<SOSMessage> messages) async {
    await init();
    final list = messages.map((m) => m.toJson()).toList();
    await _prefs!.setStringList(_keyPendingSos, list);
  }

  Future<List<SOSMessage>> loadPendingSosQueue() async {
    await init();
    final list = _prefs!.getStringList(_keyPendingSos);
    if (list == null) return [];
    final result = <SOSMessage>[];
    for (final str in list) {
      try {
        result.add(SOSMessage.fromJson(str));
      } catch (_) {}
    }
    return result;
  }

  // --- Trusted Contact ---
  Future<void> saveTrustedContact(TrustedContact contact) async {
    await init();
    await _prefs!.setString(_keyTrustedContact, json.encode(contact.toMap()));
  }

  Future<TrustedContact?> loadTrustedContact() async {
    await init();
    final str = _prefs!.getString(_keyTrustedContact);
    if (str == null) return null;
    try {
      return TrustedContact.fromMap(json.decode(str));
    } catch (_) {
      return null;
    }
  }
}
