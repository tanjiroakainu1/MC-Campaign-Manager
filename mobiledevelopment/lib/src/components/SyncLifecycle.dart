import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../context/BootstrapContext.dart';

/// Syncs Prisma data when the app resumes (mobile ↔ web alignment).
class SyncLifecycle extends StatefulWidget {
  final Widget child;
  const SyncLifecycle({super.key, required this.child});

  @override
  State<SyncLifecycle> createState() => _SyncLifecycleState();
}

class _SyncLifecycleState extends State<SyncLifecycle> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<BootstrapProvider>().silentSync();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
