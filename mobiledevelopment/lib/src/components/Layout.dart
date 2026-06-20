import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../context/SidebarContext.dart';
import '../styles/theme.dart';
import '../utils/responsive.dart';
import 'DeveloperCredit.dart';
import 'Header.dart';
import 'Sidebar.dart';

class AppLayout extends StatefulWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _lastPath;

  void _toggleDrawer() {
    final state = _scaffoldKey.currentState;
    if (state == null) return;
    if (state.isDrawerOpen) {
      state.closeDrawer();
    } else {
      state.openDrawer();
    }
  }

  void _closeDrawer() {
    _scaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    if (_lastPath != null && _lastPath != path) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _closeDrawer());
    }
    _lastPath = path;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppHeader(onMenuPressed: _toggleDrawer),
      drawer: const AppSidebar(),
      drawerEnableOpenDragGesture: true,
      onDrawerChanged: (open) {
        final sidebar = context.read<SidebarProvider>();
        if (open) {
          sidebar.open();
        } else {
          sidebar.close();
        }
      },
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.brand50, Colors.white, AppColors.diamond100],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ResponsiveContent(
                  padding: context.pagePadding,
                  child: widget.child,
                ),
              ),
            ),
            const DeveloperCredit(variant: DeveloperCreditVariant.footerLight),
          ],
        ),
      ),
    );
  }
}

class LayoutShell extends StatelessWidget {
  final Widget child;

  const LayoutShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SidebarProvider(),
      child: AppLayout(child: child),
    );
  }
}
