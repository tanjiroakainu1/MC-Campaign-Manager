import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/Modal.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';
import '../../types/index.dart';
import '../../utils/responsive.dart';

class CampaignCategories extends StatefulWidget {
  const CampaignCategories({super.key});
  @override
  State<CampaignCategories> createState() => _CampaignCategoriesState();
}

class _CampaignCategoriesState extends State<CampaignCategories> {
  bool _modalOpen = false;
  CampaignCategory? _editCat;
  final _name = TextEditingController();
  final _desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final auth = context.watch<AuthProvider>();
    final categories = dataStore.getCategories();
    return Stack(children: [
      AppScreen(children: [
        PageHeader(title: 'Campaign Categories', description: 'Organize campaigns by category', action: ElevatedButton(onPressed: _openAdd, child: const Text('Add Category'))),
        ...categories.map((cat) => AppCard(
          child: AppListItem(
            showDivider: false,
            title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${cat.description}\n${cat.campaignCount} campaigns'),
            trailing: Wrap(spacing: 8, children: [
              IconButton(onPressed: () => _openEdit(cat), icon: const Icon(Icons.edit)),
              IconButton(onPressed: () async {
                await dataStore.deleteCategory(cat.id, auth.user?.name ?? 'System');
                if (mounted) showToast(context, 'Category deleted');
                setState(() {});
              }, icon: const Icon(Icons.delete, color: Colors.red)),
            ]),
          ),
        )),
      ]),
      AppModal(isOpen: _modalOpen, onClose: () => setState(() => _modalOpen = false), title: _editCat == null ? 'Add Category' : 'Edit Category', child: FormSection(children: [
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
        TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
        ResponsiveButtonRow(
          alignment: WrapAlignment.end,
          children: [
            TextButton(onPressed: () => setState(() => _modalOpen = false), child: const Text('Cancel')),
            ElevatedButton(onPressed: () async {
            final actor = auth.user?.name ?? 'System';
            if (_editCat != null) {
              await dataStore.updateCategory(_editCat!.id, {'name': _name.text, 'description': _desc.text}, actor);
              if (mounted) showToast(context, 'Category updated');
            } else {
              await dataStore.addCategory({'name': _name.text, 'description': _desc.text}, actor);
              if (mounted) showToast(context, 'Category created');
            }
            setState(() => _modalOpen = false);
          }, child: const Text('Save')),
        ]),
      ])),
    ]);
  }

  void _openAdd() { _editCat = null; _name.clear(); _desc.clear(); setState(() => _modalOpen = true); }
  void _openEdit(CampaignCategory cat) { _editCat = cat; _name.text = cat.name; _desc.text = cat.description; setState(() => _modalOpen = true); }
}
