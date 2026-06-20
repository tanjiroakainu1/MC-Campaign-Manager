import '../lib/api.dart';
import '../config/roles.dart';
import '../types/index.dart';
import 'dataStore.dart';

class RoleAccount {
  final String role;
  final String name;
  final String email;
  final String password;
  final String userId;
  final String status;
  const RoleAccount({required this.role, required this.name, required this.email, required this.password, required this.userId, required this.status});

  factory RoleAccount.fromJson(Map<String, dynamic> json) => RoleAccount(
        role: json['role'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        password: json['password'] as String,
        userId: json['userId'] as String,
        status: json['status'] as String,
      );
}

class UserStore {
  List<RoleAccount> _demoAccounts = [];

  List<User> getAllUsers() => dataStore.getCachedUsers();
  List<User> getUsersByRole(String role) => getAllUsers().where((u) => u.role == role).toList();
  User? getUserById(String id) {
    try {
      return getAllUsers().firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadDemoAccounts() async {
    try {
      final data = await apiFetch<Map<String, dynamic>>('/auth/demo-accounts');
      _demoAccounts = (data['accounts'] as List).map((e) => RoleAccount.fromJson(e)).toList();
    } catch (_) {
      _demoAccounts = [];
    }
  }

  List<RoleAccount> getRoleAccounts() => _demoAccounts;

  Future<({User? user, String? error})> validateLogin(String email, String password) async {
    try {
      final data = await apiFetch<Map<String, dynamic>>('/auth/login', method: 'POST', body: {'email': email, 'password': password});
      return (user: User.fromJson(data['user']), error: null);
    } catch (e) {
      return (user: null, error: e.toString());
    }
  }

  Future<({bool success, String? error, User? user})> registerUser(String name, String email, String password, String role) async {
    if (!isRegistrationRole(role)) {
      return (success: false, error: 'Super Admin accounts cannot be created via registration.', user: null);
    }
    try {
      final data = await apiFetch<Map<String, dynamic>>('/auth/register', method: 'POST', body: {'name': name, 'email': email, 'password': password, 'role': role});
      final user = User.fromJson(data['user']);
      await dataStore.reload();
      await loadDemoAccounts();
      return (success: true, error: null, user: user);
    } catch (e) {
      return (success: false, error: e.toString(), user: null);
    }
  }

  Future<User> addUser(Map<String, dynamic> user, String password) async {
    final data = await apiFetch<Map<String, dynamic>>('/users', method: 'POST', body: {'user': user, 'password': password, 'actor': user['name']});
    await dataStore.reload();
    await loadDemoAccounts();
    return User.fromJson(data);
  }

  Future<User?> updateUser(String id, Map<String, dynamic> data) async {
    try {
      final result = await apiFetch<Map<String, dynamic>>('/users/$id', method: 'PATCH', body: {'data': data, 'actor': 'System'});
      await dataStore.reload();
      await loadDemoAccounts();
      return User.fromJson(result);
    } catch (_) {
      return null;
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      await apiFetch('/users/$id', method: 'DELETE', body: {'actor': 'System'});
      await dataStore.reload();
      await loadDemoAccounts();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final userStore = UserStore();
