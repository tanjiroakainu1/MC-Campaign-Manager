import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'config/api.dart';
import 'context/AuthContext.dart';
import 'context/BootstrapContext.dart';
import 'context/ConnectivityContext.dart';
import 'components/SyncLifecycle.dart';
import 'App.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load API URL from assets (release APK) or saved prefs
  String? assetApi;
  try {
    assetApi = await rootBundle.loadString('assets/config/api_base.txt');
    if (assetApi.trim().startsWith('#') || !assetApi.contains('http')) {
      assetApi = null;
    }
  } catch (_) {}

  await ApiConfig.init(assetOverride: assetApi);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => BootstrapProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const _AppRoot(),
    ),
  );
}

class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bootstrap = context.read<BootstrapProvider>();
      final connectivity = context.read<ConnectivityProvider>();
      bootstrap.bindConnectivity(connectivity);
      bootstrap.load();
      connectivity.addListener(_onConnectivityChanged);
    });
  }

  void _onConnectivityChanged() {
    final connectivity = context.read<ConnectivityProvider>();
    final bootstrap = context.read<BootstrapProvider>();
    if (connectivity.isOnline && !bootstrap.ready && !bootstrap.loading) {
      bootstrap.load();
    } else if (connectivity.isOnline && bootstrap.ready) {
      bootstrap.silentSync();
    }
  }

  @override
  void dispose() {
    try {
      context.read<ConnectivityProvider>().removeListener(_onConnectivityChanged);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SyncLifecycle(child: McmApp());
  }
}
