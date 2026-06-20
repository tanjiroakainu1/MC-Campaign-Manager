import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/roles.dart';
import '../data/userStore.dart';
import '../types/index.dart';

class AuthProvider extends ChangeNotifier {
  static const _sessionKey = 'mcm_user';
  User? _user;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_sessionKey);
    if (stored != null) {
      try {
        _user = User.fromJson(jsonDecode(stored));
        notifyListeners();
      } catch (_) {}
    }
  }

  Future<({bool success, User? user, String? error})> login(String email, String password) async {
    final result = await userStore.validateLogin(email, password);
    if (result.user != null) {
      _user = result.user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKey, jsonEncode(_user!.toJson()));
      notifyListeners();
      return (success: true, user: _user, error: null);
    }
    return (success: false, user: null, error: result.error ?? 'Invalid email or password');
  }

  Future<({bool success, String? error})> register(String name, String email, String password, String role) async {
    final result = await userStore.registerUser(name, email, password, role);
    if (result.success && result.user != null) {
      _user = result.user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKey, jsonEncode(_user!.toJson()));
      notifyListeners();
      return (success: true, error: null);
    }
    return (success: false, error: result.error);
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    notifyListeners();
  }

  String dashboardPath([String? role]) => getDashboardPath(role ?? _user?.role ?? '');
  List<RoleAccount> getRoleAccounts() => userStore.getRoleAccounts();
}
