import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/Modal.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../config/theme.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';
import '../../types/index.dart';

class UpdateContent extends StatefulWidget {
  const UpdateContent({super.key});
  @override
  State<UpdateContent> createState() => _UpdateContentState();
}

class _UpdateContentState extends State<UpdateContent> {
  Content? _editing;
  final _title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final user = context.watch<AuthProvider>().user!;
    final content = dataStore.getContentByUser(user.id);
    return Stack(children: [
      AppScreen(children: [
        const PageHeader(title: 'Update Content', description: 'Edit and resubmit your content'),
        ...content.map((item) => AppCard(
          child: AppListItem(
            showDivider: false,
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${item.type} · ${item.status}'),
            trailing: Wrap(children: [
              IconButton(onPressed: () { _editing = item; _title.text = item.title; setState(() {}); }, icon: const Icon(Icons.edit)),
              if (item.status == 'draft') TextButton(onPressed: () async {
                await dataStore.updateContent(item.id, {'status': 'pending'}, user.name);
                showToast(context, 'Submitted for approval');
                setState(() {});
              }, child: const Text('Submit')),
            ]),
          ),
        )),
      ]),
      AppModal(isOpen: _editing != null, onClose: () => setState(() => _editing = null), title: 'Edit Content', child: FormSection(children: [
        TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
        ElevatedButton(onPressed: () async {
          if (_editing != null) {
            await dataStore.updateContent(_editing!.id, {'title': _title.text}, user.name);
            showToast(context, 'Content updated');
            setState(() => _editing = null);
          }
        }, child: const Text('Save')),
      ])),
    ]);
  }
}
