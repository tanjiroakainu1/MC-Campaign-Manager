import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'components/Layout.dart';
import 'components/ProtectedRoute.dart';
import 'context/AuthContext.dart';
import 'context/BootstrapContext.dart';
import 'context/ConnectivityContext.dart';
import 'pages/ApiSetup.dart';
import 'pages/Home.dart';
import 'pages/Login.dart';
import 'pages/Register.dart';
import 'roles/content-creator/index.dart';
import 'roles/marketing-analyst/index.dart';
import 'roles/marketing-manager/index.dart';
import 'roles/super-admin/index.dart';
import 'styles/theme.dart';
import 'types/index.dart';

class McmApp extends StatelessWidget {
  const McmApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bootstrap = context.watch<BootstrapProvider>();
    final connectivity = context.watch<ConnectivityProvider>();

    if (bootstrap.needsApiSetup) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const ApiSetupPage(required: true),
      );
    }

    if (!connectivity.isOnline && !bootstrap.ready) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: _OfflineScreen(onRetry: () async {
          await connectivity.refresh();
          if (connectivity.isOnline) await bootstrap.load();
        }),
      );
    }

    if (bootstrap.loading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.brand50, Colors.white, AppColors.diamond100],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 48, height: 48, child: CircularProgressIndicator(strokeWidth: 3)),
                  SizedBox(height: 20),
                  Text('Syncing with Prisma database…', style: TextStyle(color: AppColors.brand700, fontWeight: FontWeight.w700, fontSize: 15)),
                  SizedBox(height: 6),
                  Text('Loading campaigns, users & content', style: TextStyle(color: AppColors.slate500, fontSize: 13)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (bootstrap.error != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 48, color: AppColors.slate500),
                  const SizedBox(height: 16),
                  const Text('Could not sync with database', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(bootstrap.error!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.slate500)),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: bootstrap.load, child: const Text('Retry')),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ApiSetupPage(required: true)),
                    ),
                    child: const Text('Configure API Server'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final auth = context.watch<AuthProvider>();
    final router = GoRouter(
      initialLocation: '/',
      refreshListenable: auth,
      redirect: (context, state) {
        if (state.uri.path == '/' && auth.isAuthenticated) {
          return auth.dashboardPath();
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => auth.isAuthenticated ? _RedirectDashboard(auth: auth) : const Home(),
        ),
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
        GoRoute(path: '/api-setup', builder: (context, state) => const ApiSetupPage()),
        ShellRoute(
          builder: (context, state, child) => LayoutShell(child: child),
          routes: [
            _roleRoute('/super-admin', UserRoles.superAdmin, const SuperAdminDashboard()),
            _roleRoute('/super-admin/users', UserRoles.superAdmin, const UserManagement()),
            _roleRoute('/super-admin/settings', UserRoles.superAdmin, const SystemSettingsPage()),
            _roleRoute('/super-admin/categories', UserRoles.superAdmin, const CampaignCategories()),
            _roleRoute('/super-admin/campaigns', UserRoles.superAdmin, const AllCampaigns()),
            _roleRoute('/super-admin/reports', UserRoles.superAdmin, const SystemReports()),
            _roleRoute('/marketing-manager', UserRoles.marketingManager, const MarketingManagerDashboard()),
            _roleRoute('/marketing-manager/create', UserRoles.marketingManager, const CreateCampaign()),
            _roleRoute('/marketing-manager/approve', UserRoles.marketingManager, const ApproveCampaigns()),
            _roleRoute('/marketing-manager/budget', UserRoles.marketingManager, const BudgetManagement()),
            _roleRoute('/marketing-manager/tasks', UserRoles.marketingManager, const TaskAssignment()),
            _roleRoute('/marketing-manager/monitor', UserRoles.marketingManager, const PerformanceMonitor()),
            _roleRoute('/marketing-manager/strategies', UserRoles.marketingManager, const MarketingStrategies()),
            _roleRoute('/marketing-manager/reports', UserRoles.marketingManager, const CampaignReports()),
            _roleRoute('/content-creator', UserRoles.contentCreator, const ContentCreatorDashboard()),
            _roleRoute('/content-creator/create', UserRoles.contentCreator, const CreateContent()),
            _roleRoute('/content-creator/upload', UserRoles.contentCreator, const MediaUpload()),
            _roleRoute('/content-creator/design', UserRoles.contentCreator, const DesignMaterials()),
            _roleRoute('/content-creator/schedule', UserRoles.contentCreator, const ContentSchedule()),
            _roleRoute('/content-creator/update', UserRoles.contentCreator, const UpdateContent()),
            _roleRoute('/content-creator/submit', UserRoles.contentCreator, const SubmitApproval()),
            _roleRoute('/content-creator/assigned', UserRoles.contentCreator, const AssignedCampaigns()),
            _roleRoute('/marketing-analyst', UserRoles.marketingAnalyst, const MarketingAnalystDashboard()),
            _roleRoute('/marketing-analyst/metrics', UserRoles.marketingAnalyst, const CampaignMetrics()),
            _roleRoute('/marketing-analyst/analysis', UserRoles.marketingAnalyst, const PerformanceAnalysis()),
            _roleRoute('/marketing-analyst/engagement', UserRoles.marketingAnalyst, const AudienceEngagement()),
            _roleRoute('/marketing-analyst/roi', UserRoles.marketingAnalyst, const ROITracking()),
            _roleRoute('/marketing-analyst/reports', UserRoles.marketingAnalyst, const AnalyticsReports()),
            _roleRoute('/marketing-analyst/export', UserRoles.marketingAnalyst, const DataExport()),
            _roleRoute('/marketing-analyst/dashboard', UserRoles.marketingAnalyst, const PerformanceDashboard()),
          ],
        ),
      ],
      errorBuilder: (context, state) => const Home(),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Campaign Manager',
      theme: buildAppTheme(),
      routerConfig: router,
    );
  }

  static GoRoute _roleRoute(String path, String role, Widget screen) {
    return GoRoute(
      path: path,
      builder: (context, state) => ProtectedRoute(allowedRoles: [role], child: screen),
    );
  }
}

class _OfflineScreen extends StatelessWidget {
  final VoidCallback onRetry;
  const _OfflineScreen({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.brand50, Colors.white, AppColors.diamond100],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.brand100),
                    boxShadow: [BoxShadow(color: AppColors.brand600.withValues(alpha: 0.08), blurRadius: 16, offset: Offset(0, 4))],
                  ),
                  child: const Icon(Icons.wifi_off, size: 40, color: AppColors.slate500),
                ),
                const SizedBox(height: 24),
                const Text('You\'re offline', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                const SizedBox(height: 10),
                const Text(
                  'This app requires an internet connection to sync with the Prisma database.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.slate500, height: 1.5),
                ),
                const SizedBox(height: 28),
                ElevatedButton(onPressed: onRetry, child: const Text('Try again')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RedirectDashboard extends StatelessWidget {
  final AuthProvider auth;
  const _RedirectDashboard({required this.auth});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) context.go(auth.dashboardPath());
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
