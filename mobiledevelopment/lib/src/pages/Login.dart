import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../components/PublicShell.dart';
import '../components/common/AppUI.dart';
import '../config/publicContent.dart';
import '../config/roles.dart';
import '../config/theme.dart';
import '../context/AuthContext.dart';
import '../types/index.dart';
import '../utils/responsive.dart';
import '../styles/theme.dart';

enum AuthTab { login, register }

class LoginPage extends StatefulWidget {
  final AuthTab initialTab;

  const LoginPage({super.key, this.initialTab = AuthTab.login});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthTab _tab;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _name = TextEditingController();
  String _role = UserRoles.contentCreator;
  String _error = '';
  String _success = '';

  @override
  void initState() {
    super.initState();
    _tab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final roleAccounts = auth.getRoleAccounts();

    return PublicShell(
      active: _tab == AuthTab.register ? PublicShellActive.register : PublicShellActive.login,
      showFooter: false,
      child: Center(
        child: SingleChildScrollView(
          padding: context.pagePadding,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
            Text(
              _tab == AuthTab.login ? 'Welcome Back' : 'Create Your Account',
              style: TextStyle(fontSize: context.isMobile ? 22 : 28, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _tab == AuthTab.login ? 'Sign in to access your role dashboard and sidebar navigation' : 'Register with a role to join the campaign management workflow',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.brand100),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: () => _switchTab(AuthTab.login), style: OutlinedButton.styleFrom(backgroundColor: _tab == AuthTab.login ? AppColors.brand50 : null), child: const Text('Sign In'))),
                        const SizedBox(width: 8),
                        Expanded(child: OutlinedButton(onPressed: () => _switchTab(AuthTab.register), style: OutlinedButton.styleFrom(backgroundColor: _tab == AuthTab.register ? AppColors.brand50 : null), child: const Text('Register'))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_error.isNotEmpty) Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(12)), child: Text(_error, style: const TextStyle(color: Color(0xFF991B1B)))),
                    if (_success.isNotEmpty) Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.brand50, borderRadius: BorderRadius.circular(12)), child: Text(_success, style: const TextStyle(color: AppColors.brand800))),
                    if (_tab == AuthTab.login) _loginForm(auth) else _registerForm(auth),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quick Access — All Roles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Text('One-click login with demo accounts.'),
                    const SizedBox(height: 16),
                    ...roleAccounts.map((account) {
                      final style = roleQuickAccess[account.role]!;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: style.cardBackground,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(spacing: 8, children: [roleBadge(account.role), statusBadge(account.status)]),
                              Text(account.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(account.email, style: const TextStyle(color: AppColors.slate500)),
                              Text(roleDescriptions[account.role] ?? '', style: const TextStyle(fontSize: 12, color: AppColors.slate500)),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: style.buttonBackground, foregroundColor: style.buttonForeground),
                                  onPressed: () => _quickAccess(auth, account.email, account.password),
                                  child: const Text('Go to Dashboard'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            TextButton(onPressed: () => context.go('/'), child: const Text('← Back to Home', style: TextStyle(color: AppColors.brand100))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm(AuthProvider auth) {
    return FormSection(
      children: [
        TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
        TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => _handleLogin(auth), child: const Text('Sign In'))),
      ],
    );
  }

  Widget _registerForm(AuthProvider auth) {
    return FormSection(
      children: [
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'Full Name')),
        TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
        DropdownButtonFormField(
          value: _role,
          decoration: const InputDecoration(labelText: 'Role'),
          items: registrationRoleLabels.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
          onChanged: (v) => setState(() => _role = v ?? UserRoles.contentCreator),
        ),
        Text(roleDescriptions[_role] ?? '', style: const TextStyle(fontSize: 12, color: AppColors.slate500)),
        TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
        TextField(controller: _confirmPassword, decoration: const InputDecoration(labelText: 'Confirm Password'), obscureText: true),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => _handleRegister(auth), child: const Text('Create Account'))),
      ],
    );
  }

  void _switchTab(AuthTab tab) {
    setState(() {
      _tab = tab;
      _error = '';
      _success = '';
    });
    context.go(tab == AuthTab.register ? '/register' : '/login');
  }

  Future<void> _handleLogin(AuthProvider auth) async {
    setState(() { _error = ''; _success = ''; });
    final result = await auth.login(_email.text, _password.text);
    if (result.success && result.user != null && mounted) {
      context.go(auth.dashboardPath(result.user!.role));
    } else {
      setState(() => _error = result.error ?? 'Login failed');
    }
  }

  Future<void> _handleRegister(AuthProvider auth) async {
    setState(() { _error = ''; _success = ''; });
    if (_password.text != _confirmPassword.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    final result = await auth.register(_name.text, _email.text, _password.text, _role);
    if (result.success) {
      setState(() => _success = 'Account created! Redirecting to your dashboard...');
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) context.go(auth.dashboardPath(_role));
    } else {
      setState(() => _error = result.error ?? 'Registration failed');
    }
  }

  Future<void> _quickAccess(AuthProvider auth, String email, String password) async {
    setState(() { _email.text = email; _password.text = password; _error = ''; _success = ''; });
    final result = await auth.login(email, password);
    if (result.success && result.user != null && mounted) {
      context.go(roleDashboardPaths[result.user!.role] ?? '/login');
    } else {
      setState(() => _error = result.error ?? 'Quick access login failed');
    }
  }
}
