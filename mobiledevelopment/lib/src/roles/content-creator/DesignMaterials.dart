import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../config/theme.dart';
import '../../styles/theme.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';
import '../../types/index.dart';
import '../../utils/responsive.dart';

class DesignMaterials extends StatefulWidget {
  const DesignMaterials({super.key});
  @override
  State<DesignMaterials> createState() => _DesignMaterialsState();
}

class _DesignMaterialsState extends State<DesignMaterials> {
  DesignTemplate? _selectedTemplate;
  String? _fileName;

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final user = context.watch<AuthProvider>().user!;
    final designs = dataStore.getDesignsByUser(user.id);
    final templates = dataStore.getDesignTemplates();
    return AppScreen(children: [
      const PageHeader(title: 'Design Materials', description: 'Create designs from Prisma templates'),
      if (_selectedTemplate != null) AppCard(title: 'Editing: ${_selectedTemplate!.name}', child: FormSection(children: [
        Container(height: 120, width: double.infinity, color: AppColors.brand50, alignment: Alignment.center, child: Text(_selectedTemplate!.size, style: const TextStyle(color: AppColors.slate500))),
        ResponsiveButtonRow(children: [
          OutlinedButton(onPressed: () async {
            final result = await FilePicker.platform.pickFiles();
            if (result != null) setState(() => _fileName = result.files.first.name);
          }, child: Text(_fileName ?? 'Choose File')),
          TextButton(onPressed: () => showToast(context, 'Text tool coming soon'), child: const Text('Add Text')),
        ]),
        ResponsiveButtonRow(children: [
          ElevatedButton(onPressed: () async {
            await dataStore.addDesign({
              'name': _selectedTemplate!.name,
              'template': _selectedTemplate!.id,
              'fileName': _fileName,
              'fileType': _fileName?.split('.').last,
              'savedAt': DateTime.now().toIso8601String().split('T').first,
              'createdBy': user.id,
              'status': 'saved',
            }, user.name);
            if (_fileName != null) {
              await dataStore.addMedia({'name': _fileName!, 'type': 'image', 'size': '1 KB', 'uploadedAt': DateTime.now().toIso8601String().split('T').first, 'uploadedBy': user.id}, user.name);
            }
            showToast(context, 'Design saved');
            setState(() { _selectedTemplate = null; _fileName = null; });
          }, child: const Text('Saved')),
          TextButton(onPressed: () => setState(() => _selectedTemplate = null), child: const Text('Close')),
        ]),
      ])),
      const SectionHeader(title: 'Saved Designs'),
      ...designs.map((d) => AppCard(
        child: AppListItem(
          showDivider: false,
          title: Text(d.name),
          subtitle: Text(d.template),
          trailing: statusBadge(d.status),
        ),
      )),
      const SectionHeader(title: 'Templates'),
      ...templates.map((t) => AppCard(
        child: AppListItem(
          showDivider: false,
          title: Text(t.name),
          subtitle: Text('${t.category} · ${t.size}'),
          trailing: ElevatedButton(onPressed: () => setState(() => _selectedTemplate = t), child: const Text('Use Template')),
        ),
      )),
    ]);
  }
}
