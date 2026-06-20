import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:shared_preferences/shared_preferences.dart';

/// Online API config — APK release builds sync with Prisma via deployed Express API.
///
/// Priority: SharedPreferences (user-saved) → dart-define API_BASE → release asset → dev defaults

const int syncIntervalMs = 20000;
const int apiPort = 3001;
const String apiBasePrefKey = 'mcm_api_base';

/// Set at build time for release APK:
/// flutter build apk --dart-define=API_BASE=https://your-server.com/api
const String _dartDefineApiBase = String.fromEnvironment('API_BASE', defaultValue: '');

/// Optional: set in assets/config/api_base.txt before building APK (loaded in main.dart)

class ApiConfig {
  static String? _resolvedBase;
  static bool _initialized = false;

  static String get baseUrl {
    if (_resolvedBase != null && _resolvedBase!.isNotEmpty) return _resolvedBase!;
    if (kReleaseMode) return '';
    return _devDefault();
  }

  static bool get isConfigured => _resolvedBase != null && _resolvedBase!.isNotEmpty;

  static Future<void> init({String? assetOverride}) async {
    if (_initialized) return;
    _initialized = true;

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(apiBasePrefKey)?.trim();
    if (saved != null && saved.isNotEmpty) {
      _resolvedBase = _normalize(saved);
      return;
    }

    if (_dartDefineApiBase.isNotEmpty) {
      _resolvedBase = _normalize(_dartDefineApiBase);
      await prefs.setString(apiBasePrefKey, _resolvedBase!);
      return;
    }

    if (assetOverride != null && assetOverride.trim().isNotEmpty) {
      _resolvedBase = _normalize(assetOverride.trim());
      await prefs.setString(apiBasePrefKey, _resolvedBase!);
      return;
    }

    if (kReleaseMode) {
      // Release APK must have a remote URL — no localhost fallback
      _resolvedBase = null;
      return;
    }

    _resolvedBase = _normalize(_devDefault());
  }

  static Future<void> saveBaseUrl(String url) async {
    _resolvedBase = _normalize(url);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(apiBasePrefKey, _resolvedBase!);
  }

  static Future<void> clearSavedUrl() async {
    _resolvedBase = null;
    _initialized = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(apiBasePrefKey);
    await init();
  }

  static String _normalize(String url) {
    var u = url.trim();
    if (!u.endsWith('/api')) {
      u = u.endsWith('/') ? '${u}api' : '$u/api';
    }
    return u;
  }

  static String _devDefault() {
    if (kIsWeb) return 'http://127.0.0.1:$apiPort/api';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:$apiPort/api';
    } catch (_) {}
    return 'http://127.0.0.1:$apiPort/api';
  }
}

String resolveApiBase() => ApiConfig.baseUrl;
