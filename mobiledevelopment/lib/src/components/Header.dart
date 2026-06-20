import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/roles.dart';
import '../context/AuthContext.dart';
import '../context/BootstrapContext.dart';
import '../context/ConnectivityContext.dart';
import '../context/SidebarContext.dart';
import '../data/dataStore.dart';
import '../styles/theme.dart';
import '../utils/responsive.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;

  const AppHeader({super.key, this.onMenuPressed});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final bootstrap = context.watch<BootstrapProvider>();
    final connectivity = context.watch<ConnectivityProvider>();
    final sidebar = context.watch<SidebarProvider>();
    final user = auth.user;
    if (user == null) return const SizedBox.shrink();

    final notifications = dataStore.getNotifications().where((n) => !n.read).toList();
    final compact = context.compactHeader;

    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.brand900, AppColors.brand800, AppColors.brand700],
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(sidebar.isOpen ? Icons.close : Icons.menu),
        tooltip: sidebar.isOpen ? 'Close menu' : 'Open menu',
        onPressed: onMenuPressed,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            compact ? 'Campaign Manager' : 'Campaign Manager',
            style: TextStyle(fontSize: compact ? 14 : 15),
            overflow: TextOverflow.ellipsis,
          ),
          roleBadge(user.role),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            connectivity.isOnline ? Icons.cloud_done : Icons.cloud_off,
            color: connectivity.isOnline ? Colors.lightGreenAccent : Colors.redAccent,
            size: 18,
          ),
        ),
        if (compact)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _handleMenu(context, value, auth, bootstrap, connectivity, sidebar),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'sync', child: ListTile(leading: Icon(Icons.sync), title: Text('Sync'), contentPadding: EdgeInsets.zero)),
              const PopupMenuItem(value: 'api', child: ListTile(leading: Icon(Icons.settings_ethernet), title: Text('API Settings'), contentPadding: EdgeInsets.zero)),
              PopupMenuItem(
                value: 'notif',
                child: ListTile(
                  leading: Badge(isLabelVisible: notifications.isNotEmpty, label: Text('${notifications.length}'), child: const Icon(Icons.notifications_outlined)),
                  title: Text('Notifications (${notifications.length})'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(value: 'logout', child: ListTile(leading: Icon(Icons.logout), title: Text('Logout'), contentPadding: EdgeInsets.zero)),
            ],
          )
        else ...[
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sync with Prisma',
            onPressed: connectivity.isOnline ? () => bootstrap.silentSync() : null,
          ),
          IconButton(
            icon: const Icon(Icons.settings_ethernet),
            tooltip: 'API server settings',
            onPressed: () => context.push('/api-setup'),
          ),
          PopupMenuButton<void>(
            icon: Badge(
              isLabelVisible: notifications.isNotEmpty,
              label: Text('${notifications.length}'),
              child: const Icon(Icons.notifications_outlined),
            ),
            itemBuilder: (context) {
              if (notifications.isEmpty) {
                return [const PopupMenuItem<void>(enabled: false, child: Text('No new notifications'))];
              }
              return notifications
                  .map((n) => PopupMenuItem<void>(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(n.message, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        onTap: () => dataStore.markNotificationRead(n.id),
                      ))
                  .toList();
            },
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context, auth, sidebar),
          ),
        ],
      ],
    );
  }

  void _handleMenu(BuildContext context, String value, AuthProvider auth, BootstrapProvider bootstrap, ConnectivityProvider connectivity, SidebarProvider sidebar) {
    switch (value) {
      case 'sync':
        if (connectivity.isOnline) bootstrap.silentSync();
        break;
      case 'api':
        context.push('/api-setup');
        break;
      case 'notif':
        break;
      case 'logout':
        _logout(context, auth, sidebar);
        break;
    }
  }

  Future<void> _logout(BuildContext context, AuthProvider auth, SidebarProvider sidebar) async {
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold?.isDrawerOpen ?? false) {
      scaffold!.closeDrawer();
    }
    await auth.logout();
    if (context.mounted) context.go('/login');
    sidebar.close();
  }
}
