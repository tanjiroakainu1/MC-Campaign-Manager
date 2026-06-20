import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/DeveloperCredit.dart';
import '../components/PublicShell.dart';
import '../config/publicContent.dart';
import '../config/roles.dart';
import '../data/userStore.dart';
import '../utils/responsive.dart';
import '../styles/theme.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final roles = userStore.getRoleAccounts();

    return PublicShell(
      active: PublicShellActive.home,
      child: Column(
        children: [
          Padding(
            padding: context.pagePadding,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Text('BLUE DIAMOND THEME', style: TextStyle(color: AppColors.brand100, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ),
                const SizedBox(height: 24),
                Text(
                  'Plan, Create & Measure Campaigns — Together',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.isMobile ? 24 : context.isTablet ? 28 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'A role-based platform where Super Admins, Marketing Managers, Content Creators, and Analysts collaborate on campaigns from planning through performance tracking.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.brand100, height: 1.5),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () => context.go('/register'), child: const Text('Create Free Account')),
                    OutlinedButton(onPressed: () => context.go('/login'), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54)), child: const Text('Sign In to Dashboard')),
                  ],
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: const [
                    _HeroStat(value: '4', label: 'Specialized Roles'),
                    _HeroStat(value: '28+', label: 'Feature Pages'),
                    _HeroStat(value: '1', label: 'Unified Workflow'),
                    _HeroStat(value: '∞', label: 'Campaigns Tracked'),
                  ],
                ),
              ],
            ),
          ),
          _section(context, title: 'Platform Features', child: Column(
              children: platformFeatures.map((f) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(_featureIcon(f.icon), color: AppColors.brand600),
                      title: Text(f.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(f.description),
                    ),
                  )).toList(),
            ),
          ),
          _section(context,
            title: 'How the System Works',
            subtitle: 'From your first sign-in to running full campaigns.',
            child: Column(
              children: getStartedSteps.map((step) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: AppColors.brand600, child: Text('${step.step}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      title: Text(step.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.slate900)),
                      subtitle: Text(step.description),
                    ),
                  )).toList(),
            ),
          ),
          _section(
            context,
            title: 'Campaign Lifecycle Flow',
            subtitle: 'Campaigns move through four phases — each role owns a stage.',
            child: context.isMobile
                ? Column(
                    children: campaignLifecycle.map((stage) => _lifecycleCard(stage)).toList(),
                  )
                : SizedBox(
                    height: 220,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: campaignLifecycle.map((stage) {
                        return Container(
                          width: 260,
                          margin: const EdgeInsets.only(right: 12),
                          child: _lifecycleCard(stage),
                        );
                      }).toList(),
                    ),
                  ),
          ),
          _section(context,
            title: 'Explore Each Role',
            subtitle: 'Every role has a dedicated dashboard and feature pages.',
            child: Column(
              children: roles.map((account) {
                final style = roleQuickAccess[account.role]!;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: style.cardBackground,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: style.cardBorder)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [roleBadge(account.role)]),
                        Text(getRoleLabel(account.role), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.slate900)),
                        Text(roleDescriptions[account.role] ?? '', style: const TextStyle(color: AppColors.slate500)),
                        const SizedBox(height: 8),
                        ...getRoleFeatures(account.role).map((f) => Row(children: [const Icon(Icons.check, size: 16, color: AppColors.diamond500), const SizedBox(width: 8), Expanded(child: Text(f, style: const TextStyle(color: AppColors.slate500)))])),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('DEMO ACCOUNT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.slate500)),
                            Text(account.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(account.email, style: const TextStyle(fontSize: 12, color: AppColors.slate500)),
                          ]),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: style.buttonBackground, foregroundColor: style.buttonForeground),
                            onPressed: () => context.go('/login'),
                            child: Text('Try ${getRoleLabel(account.role)} Dashboard'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const DeveloperCredit(variant: DeveloperCreditVariant.hero),
          Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Ready to get started?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.slate900)),
                  const SizedBox(height: 8),
                  const Text('Register for your role, or sign in with a demo account on the login page.', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(onPressed: () => context.go('/register'), child: const Text('Register Now')),
                      OutlinedButton(onPressed: () => context.go('/login'), child: const Text('Sign In')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, {required String title, String? subtitle, required Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.isMobile ? 12 : 16, vertical: context.isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: context.isMobile ? 20 : 24, fontWeight: FontWeight.bold, color: Colors.white)),
          if (subtitle != null) Padding(padding: const EdgeInsets.only(top: 8, bottom: 16), child: Text(subtitle, style: const TextStyle(color: AppColors.brand100))),
          child,
        ],
      ),
    );
  }

  Widget _lifecycleCard(dynamic stage) {
    final style = roleQuickAccess[stage.role]!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: style.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: style.cardBorder)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(spacing: 8, runSpacing: 8, children: [roleBadge(stage.role), Chip(label: Text(stage.phase))]),
            const SizedBox(height: 12),
            Text(stage.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.slate900)),
            Text(stage.description, style: const TextStyle(color: AppColors.slate500, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  IconData _featureIcon(String icon) {
    switch (icon) {
      case 'shield':
        return Icons.shield_outlined;
      case 'flow':
        return Icons.bolt;
      case 'database':
        return Icons.storage;
      default:
        return Icons.phone_android;
    }
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;
  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final horizontalPad = context.pagePadding.horizontal;
    final width = context.isMobile
        ? ((context.screenWidth - horizontalPad - 12) / 2).clamp(100.0, 160.0)
        : 140.0;
    return SizedBox(
      width: width,
      child: Container(
        padding: EdgeInsets.all(context.isMobile ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: context.isMobile ? 22 : 28, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.brand200)),
          ],
        ),
      ),
    );
  }
}
