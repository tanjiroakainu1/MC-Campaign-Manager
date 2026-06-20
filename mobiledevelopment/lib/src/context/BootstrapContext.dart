import 'dart:async';
import 'package:flutter/foundation.dart';
import '../config/api.dart';
import '../data/dataStore.dart';
import '../data/userStore.dart';
import 'ConnectivityContext.dart';

class BootstrapProvider extends ChangeNotifier {
  bool _ready = false;
  bool _loading = true;
  String? _error;
  bool _needsApiSetup = false;
  DateTime? _lastSyncedAt;
  Timer? _syncTimer;
  bool _syncing = false;
  ConnectivityProvider? _connectivity;

  bool get ready => _ready;
  bool get loading => _loading;
  String? get error => _error;
  bool get needsApiSetup => _needsApiSetup;
  DateTime? get lastSyncedAt => _lastSyncedAt;

  void bindConnectivity(ConnectivityProvider connectivity) {
    _connectivity = connectivity;
  }

  BootstrapProvider() {
    dataStore.addListener(_onDataChanged);
    _syncTimer = Timer.periodic(const Duration(milliseconds: syncIntervalMs), (_) => silentSync());
  }

  void _onDataChanged() => notifyListeners();

  Future<void> load() async {
    if (_connectivity != null && !_connectivity!.isOnline) {
      _error = 'No internet connection. Connect to Wi‑Fi or mobile data to sync with Prisma.';
      _loading = false;
      _ready = false;
      notifyListeners();
      return;
    }

    if (!ApiConfig.isConfigured && resolveApiBase().isEmpty) {
      _needsApiSetup = true;
      _loading = false;
      _ready = false;
      _error = null;
      notifyListeners();
      return;
    }

    _loading = true;
    _error = null;
    _needsApiSetup = false;
    _ready = false;
    notifyListeners();
    try {
      await dataStore.hydrate();
      await userStore.loadDemoAccounts();
      _lastSyncedAt = DateTime.now();
      _ready = true;
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('not configured') || msg.contains('Cannot reach server')) {
        _needsApiSetup = true;
        _error = null;
      } else {
        _error = msg;
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> silentSync() async {
    if (_syncing || _loading || _needsApiSetup) return;
    if (_connectivity != null && !_connectivity!.isOnline) return;
    if (!ApiConfig.isConfigured && resolveApiBase().isEmpty) return;

    _syncing = true;
    try {
      await dataStore.reload();
      _lastSyncedAt = DateTime.now();
      _error = null;
      _ready = true;
      notifyListeners();
    } catch (_) {
      /* keep last good cache when background sync fails */
    } finally {
      _syncing = false;
    }
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    dataStore.removeListener(_onDataChanged);
    super.dispose();
  }
}
