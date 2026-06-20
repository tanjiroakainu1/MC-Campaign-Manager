import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/common/AppUI.dart';
import '../config/api.dart';
import '../context/BootstrapContext.dart';
import '../styles/theme.dart';
import '../utils/responsive.dart';

class ApiSetupPage extends StatefulWidget {
  final bool required;
  const ApiSetupPage({super.key, this.required = false});

  @override
  State<ApiSetupPage> createState() => _ApiSetupPageState();
}

class _ApiSetupPageState extends State<ApiSetupPage> {
  final _controller = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final current = ApiConfig.baseUrl;
    if (ApiConfig.isConfigured) {
      _controller.text = current.replaceAll('/api', '');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final raw = _controller.text.trim();
    if (raw.isEmpty) {
      setState(() => _error = 'Enter your online API server URL');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ApiConfig.saveBaseUrl(raw);
      if (mounted) {
        await context.read<BootstrapProvider>().load();
        if (mounted && !widget.required) Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Server'),
        automaticallyImplyLeading: !widget.required,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: context.pagePadding,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: AppCard(
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.brand100, AppColors.diamond100]),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.brand100),
                    ),
                    child: const Icon(Icons.cloud_done_outlined, size: 36, color: AppColors.brand600),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.required ? 'Connect to Prisma Database' : 'API Server Settings',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter the URL of your online Express API. The app syncs campaigns, users, and content from Prisma Postgres via /api/sync.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.slate500, fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  FormSection(
                    children: [
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'API Server URL',
                          hintText: 'https://your-server.com or http://192.168.1.10:3001',
                          prefixIcon: Icon(Icons.link),
                        ),
                        keyboardType: TextInputType.url,
                        autocorrect: false,
                      ),
                      const Text(
                        '/api is appended automatically if missing.',
                        style: TextStyle(fontSize: 12, color: AppColors.slate500),
                      ),
                      if (_error != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFECACA)),
                          ),
                          child: Text(_error!, style: const TextStyle(color: Color(0xFF991B1B), fontSize: 13)),
                        ),
                      ElevatedButton(
                        onPressed: _saving ? null : _save,
                        child: _saving
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Connect & Sync'),
                      ),
                      if (!widget.required)
                        TextButton(
                          onPressed: () async {
                            await ApiConfig.clearSavedUrl();
                            if (context.mounted) context.read<BootstrapProvider>().load();
                          },
                          child: const Text('Reset to default'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
