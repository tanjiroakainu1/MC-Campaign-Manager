import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class ApiError implements Exception {
  final String message;
  final int status;
  ApiError(this.message, this.status);
  @override
  String toString() => message;
}

Future<T> apiFetch<T>(
  String path, {
  String method = 'GET',
  Map<String, dynamic>? body,
}) async {
  final base = resolveApiBase();
  if (base.isEmpty) {
    throw ApiError('API server not configured. Set your online server URL.', 0);
  }

  final uri = Uri.parse('$base$path');
  final headers = {'Content-Type': 'application/json'};

  late http.Response res;
  try {
    switch (method.toUpperCase()) {
      case 'POST':
        res = await http.post(uri, headers: headers, body: body != null ? jsonEncode(body) : null);
        break;
      case 'PATCH':
        res = await http.patch(uri, headers: headers, body: body != null ? jsonEncode(body) : null);
        break;
      case 'DELETE':
        res = await http.delete(uri, headers: headers, body: body != null ? jsonEncode(body) : null);
        break;
      default:
        res = await http.get(uri, headers: headers);
    }
  } catch (e) {
    throw ApiError('Cannot reach server. Check your internet and API URL.', 0);
  }

  final data = res.body.isNotEmpty ? jsonDecode(res.body) : <String, dynamic>{};

  if (res.statusCode < 200 || res.statusCode >= 300) {
    final err = data is Map ? (data['error'] as String?) ?? 'Request failed' : 'Request failed';
    throw ApiError(err, res.statusCode);
  }

  return data as T;
}

/// Verify the online API + Prisma database are reachable.
Future<bool> checkApiHealth() async {
  try {
    final data = await apiFetch<Map<String, dynamic>>('/health');
    return data['ok'] == true && data['database'] == 'connected';
  } catch (_) {
    return false;
  }
}
