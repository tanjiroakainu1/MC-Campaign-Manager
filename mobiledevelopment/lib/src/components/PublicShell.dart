import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'DeveloperCredit.dart';
import '../styles/theme.dart';
import '../utils/responsive.dart';

enum PublicShellActive { home, login, register }

class PublicShell extends StatefulWidget {
  final Widget child;
  final PublicShellActive active;
  final bool showFooter;

  const PublicShell({
    super.key,
    required this.child,
    this.active = PublicShellActive.home,
    this.showFooter = true,
  });

  @override
  State<PublicShell> createState() => _PublicShellState();
}

class _PublicShellState extends State<PublicShell> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brand900,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.brand800, AppColors.brand900, AppColors.diamond600],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              if (_menuOpen) _buildMobileMenu(context),
              Expanded(child: SingleChildScrollView(child: widget.child)),
              if (widget.showFooter) _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final compact = context.compactHeader;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 16, vertical: 8),
      decoration: BoxDecoration(color: AppColors.brand900.withValues(alpha: 0.75)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/'),
            child: Row(
              children: [
                _logo(size: compact ? 32 : 36),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Campaign Manager', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: compact ? 14 : 16)),
                    if (!compact) const Text('Blue Diamond Theme', style: TextStyle(color: AppColors.diamond200, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          if (!compact) ...[
            TextButton(onPressed: () => context.go('/login'), child: const Text('Sign In', style: TextStyle(color: Colors.white))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () => context.go('/register'), child: const Text('Get Started')),
          ] else
            IconButton(
              onPressed: () => setState(() => _menuOpen = !_menuOpen),
              icon: Icon(_menuOpen ? Icons.close : Icons.menu, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileMenu(BuildContext context) {
    return Container(
      color: AppColors.brand900.withValues(alpha: 0.95),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(title: const Text('How It Works', style: TextStyle(color: Colors.white)), onTap: () => setState(() => _menuOpen = false)),
          ListTile(title: const Text('Roles', style: TextStyle(color: Colors.white)), onTap: () => setState(() => _menuOpen = false)),
          const Divider(color: Colors.white24),
          ElevatedButton(onPressed: () => context.go('/login'), child: const Text('Sign In')),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () => context.go('/register'), child: const Text('Get Started')),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.brand900.withValues(alpha: 0.4), border: const Border(top: BorderSide(color: Colors.white10))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _logo(size: 32),
              const SizedBox(width: 8),
              const Text('Marketing Campaign Management System', style: TextStyle(color: AppColors.brand200, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          const DeveloperCredit(variant: DeveloperCreditVariant.footerDark),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            alignment: WrapAlignment.center,
            children: [
              TextButton(onPressed: () => context.go('/login'), child: const Text('Sign In')),
              TextButton(onPressed: () => context.go('/register'), child: const Text('Register')),
              const Text('4 Roles · One Platform', style: TextStyle(color: AppColors.diamond400)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _logo({double size = 36}) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.diamond200, AppColors.brand500]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text('MC', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.brand900, fontSize: size * 0.35)),
    );
  }
}
