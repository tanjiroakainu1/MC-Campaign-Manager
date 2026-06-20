import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/navigation.dart';
import '../config/roles.dart';
import '../context/AuthContext.dart';
import '../context/SidebarContext.dart';
import '../styles/theme.dart';
import '../utils/responsive.dart';
import 'DeveloperCredit.dart';

IconData navIcon(String id) {
  switch (id) {
    case 'users':
      return Icons.people_outline;
    case 'settings':
      return Icons.settings_outlined;
    case 'categories':
      return Icons.label_outline;
    case 'campaigns':
      return Icons.campaign_outlined;
    case 'reports':
      return Icons.assessment_outlined;
    case 'create':
      return Icons.add;
    case 'approve':
      return Icons.check_circle_outline;
    case 'budget':
      return Icons.attach_money;
    case 'tasks':
      return Icons.task_alt;
    case 'monitor':
      return Icons.monitor;
    case 'strategies':
      return Icons.bolt;
    case 'upload':
      return Icons.upload;
    case 'design':
      return Icons.brush_outlined;
    case 'schedule':
      return Icons.calendar_today;
    case 'update':
      return Icons.edit_outlined;
    case 'submit':
      return Icons.send_outlined;
    case 'assigned':
      return Icons.work_outline;
    case 'metrics':
      return Icons.bar_chart;
    case 'analysis':
      return Icons.search;
    case 'engagement':
      return Icons.groups_outlined;
    case 'roi':
      return Icons.trending_up;
    case 'export':
      return Icons.download;
    case 'dashboard':
      return Icons.dashboard_outlined;
    default:
      return Icons.dashboard_outlined;
  }
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    if (user == null) return const SizedBox.shrink();

    final navItems = getNavForRole(user.role);
    final dashboardPath = getDashboardPath(user.role);
    final accent = roleSidebarAccent[user.role]!;
    final currentPath = GoRouterState.of(context).uri.path;
    final drawerWidth = context.isMobile ? MediaQuery.sizeOf(context).width * 0.85 : 300.0;

    return Drawer(
      width: drawerWidth,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.brand500, AppColors.diamond400]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('MC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Campaign Manager', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(getRoleLabel(user.role), style: const TextStyle(fontSize: 12, color: AppColors.slate500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: roleBadge(user.role)),
            const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 8), child: Text('MAIN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.slate500, letterSpacing: 1.5))),
            _navTile(context, dashboardPath, 'Dashboard', Icons.dashboard_outlined, currentPath, accent),
            const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 8), child: Text('FEATURES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.slate500, letterSpacing: 1.5))),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: navItems.map((item) => _navTile(context, item.path, item.label, navIcon(item.id), currentPath, accent)).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(user.email, style: const TextStyle(fontSize: 12, color: AppColors.slate500)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const DeveloperCredit(variant: DeveloperCreditVariant.sidebar),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _closeDrawer(BuildContext context) {
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold?.isDrawerOpen ?? false) {
      scaffold!.closeDrawer();
    }
    context.read<SidebarProvider>().close();
  }

  Widget _navTile(BuildContext context, String path, String label, IconData icon, String currentPath, RoleSidebarAccent accent) {
    final active = currentPath == path;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _closeDrawer(context);
            context.go(path);
          },
          child: Ink(
            decoration: BoxDecoration(
              gradient: active ? accent.activeGradient : null,
              color: active ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: active ? null : Border.all(color: Colors.transparent),
            ),
            child: ListTile(
              leading: Icon(icon, color: active ? Colors.white : accent.iconColor, size: 22),
              title: Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: active ? Colors.white : AppColors.slate700)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
      ),
    );
  }
}
