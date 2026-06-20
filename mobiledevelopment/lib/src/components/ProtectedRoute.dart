import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../context/AuthContext.dart';

class ProtectedRoute extends StatelessWidget {
  final Widget child;
  final List<String>? allowedRoles;

  const ProtectedRoute({super.key, required this.child, this.allowedRoles});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (allowedRoles != null && auth.user != null && !allowedRoles!.contains(auth.user!.role)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/${auth.user!.role}');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return child;
  }
}
