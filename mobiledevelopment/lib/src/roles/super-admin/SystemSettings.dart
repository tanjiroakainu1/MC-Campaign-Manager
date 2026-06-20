import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/DeveloperCredit.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../context/AuthContext.dart';
import '../../data/dataStore.dart';
import '../../types/index.dart' as types;

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});
  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  late types.SystemSettings _settings;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _settings = dataStore.getSettings();
    dataStore.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    dataStore.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() => _settings = dataStore.getSettings());
  }

  Future<void> _save() async {
    final actor = context.read<AuthProvider>().user?.name ?? 'System';
    setState(() => _saving = true);
    try {
      await dataStore.updateSettings(_settings.toJson(), actor);
      if (mounted) showToast(context, 'Settings saved to database');
    } catch (_) {
      if (mounted) showToast(context, 'Failed to save settings');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(children: [
      const PageHeader(title: 'System Settings', description: 'Configure global platform settings — stored in Prisma Postgres'),
      AppCard(title: 'General', child: FormSection(children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Company Name'),
          controller: TextEditingController(text: _settings.companyName),
          onChanged: (v) => setState(() => _settings = _settings.copyWith(companyName: v)),
        ),
        DropdownButtonFormField(
          value: _settings.timezone,
          decoration: const InputDecoration(labelText: 'Timezone'),
          items: const [
            DropdownMenuItem(value: 'America/New_York', child: Text('Eastern Time')),
            DropdownMenuItem(value: 'Asia/Manila', child: Text('Asia/Manila')),
            DropdownMenuItem(value: 'UTC', child: Text('UTC')),
          ],
          onChanged: (v) => setState(() => _settings = _settings.copyWith(timezone: v!)),
        ),
        DropdownButtonFormField(
          value: _settings.currency,
          decoration: const InputDecoration(labelText: 'Currency'),
          items: const [
            DropdownMenuItem(value: 'PHP', child: Text('PHP')),
            DropdownMenuItem(value: 'USD', child: Text('USD')),
          ],
          onChanged: (v) => setState(() => _settings = _settings.copyWith(currency: v!)),
        ),
        DropdownButtonFormField(
          value: int.tryParse(_settings.sessionTimeout) ?? 30,
          decoration: const InputDecoration(labelText: 'Session Timeout (min)'),
          items: [15, 30, 60].map((v) => DropdownMenuItem(value: v, child: Text('$v'))).toList(),
          onChanged: (v) => setState(() => _settings = _settings.copyWith(sessionTimeout: '$v')),
        ),
      ])),
      AppCard(title: 'Notifications', child: FormSection(children: [
        SwitchListTile(title: const Text('Email Notifications'), value: _settings.emailNotifications, onChanged: (v) => setState(() => _settings = _settings.copyWith(emailNotifications: v))),
        SwitchListTile(title: const Text('SMS Notifications'), value: _settings.smsNotifications, onChanged: (v) => setState(() => _settings = _settings.copyWith(smsNotifications: v))),
      ])),
      AppCard(title: 'Backup & Security', child: FormSection(children: [
        SwitchListTile(title: const Text('Auto Backup'), value: _settings.autoBackup, onChanged: (v) => setState(() => _settings = _settings.copyWith(autoBackup: v))),
        DropdownButtonFormField(
          value: _settings.backupFrequency,
          decoration: const InputDecoration(labelText: 'Backup Frequency'),
          items: const [
            DropdownMenuItem(value: 'daily', child: Text('Daily')),
            DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
          ],
          onChanged: (v) => setState(() => _settings = _settings.copyWith(backupFrequency: v!)),
        ),
        DropdownButtonFormField(
          value: int.tryParse(_settings.maxUploadSize) ?? 50,
          decoration: const InputDecoration(labelText: 'Max Upload (MB)'),
          items: [10, 25, 50].map((v) => DropdownMenuItem(value: v, child: Text('$v MB'))).toList(),
          onChanged: (v) => setState(() => _settings = _settings.copyWith(maxUploadSize: '$v')),
        ),
      ])),
      const DeveloperCredit(variant: DeveloperCreditVariant.card),
      ElevatedButton(onPressed: _saving ? null : _save, child: Text(_saving ? 'Saving…' : 'Save Settings')),
    ]);
  }
}
