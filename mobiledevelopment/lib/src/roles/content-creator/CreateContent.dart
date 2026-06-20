import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';
import '../../utils/responsive.dart';

class CreateContent extends StatefulWidget {
  const CreateContent({super.key});
  @override
  State<CreateContent> createState() => _CreateContentState();
}

class _CreateContentState extends State<CreateContent> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  String _type = 'text';
  String _campaignId = '';

  Future<void> _submit(String status) async {
    final user = context.read<AuthProvider>().user!;
    await dataStore.addContent({'title': _title.text, 'type': _type, 'campaignId': _campaignId, 'status': status, 'createdBy': user.id}, user.name);
    _title.clear(); _body.clear();
    showToast(context, status == 'draft' ? 'Saved as draft' : 'Submitted for approval');
  }

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final campaigns = dataStore.getCampaigns();
    if (_campaignId.isEmpty && campaigns.isNotEmpty) _campaignId = campaigns.first.id;
    return AppScreen(children: [
      const PageHeader(title: 'Create Content', description: 'Create new campaign content'),
      AppCard(title: 'Content Details', child: FormSection(children: [
        TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
        DropdownButtonFormField(value: _type, decoration: const InputDecoration(labelText: 'Type'), items: const [DropdownMenuItem(value: 'text', child: Text('Text')), DropdownMenuItem(value: 'image', child: Text('Image')), DropdownMenuItem(value: 'video', child: Text('Video')), DropdownMenuItem(value: 'design', child: Text('Design'))], onChanged: (v) => setState(() => _type = v!)),
        DropdownButtonFormField(value: _campaignId, decoration: const InputDecoration(labelText: 'Campaign'), items: campaigns.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(), onChanged: (v) => setState(() => _campaignId = v!)),
        TextField(controller: _body, decoration: const InputDecoration(labelText: 'Body'), maxLines: 4),
        ResponsiveButtonRow(children: [
          OutlinedButton(onPressed: () => _submit('draft'), child: const Text('Save as Draft')),
          ElevatedButton(onPressed: () => _submit('pending'), child: const Text('Submit for Approval')),
        ]),
      ])),
    ]);
  }
}
