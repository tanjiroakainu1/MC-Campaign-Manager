import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../config/currency.dart';
import '../../config/theme.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';
import '../../styles/theme.dart';

class BudgetManagement extends StatefulWidget {
  const BudgetManagement({super.key});
  @override
  State<BudgetManagement> createState() => _BudgetManagementState();
}

class _BudgetManagementState extends State<BudgetManagement> {
  String? _editingId;
  final _budgetCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final campaigns = dataStore.getCampaigns();
    return AppScreen(children: [
      const PageHeader(title: 'Budget Management', description: 'Monitor and adjust campaign budgets'),
      ...campaigns.map((c) {
        final pct = c.budget > 0 ? (c.spent / c.budget * 100) : 0.0;
        return AppCard(title: c.name, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Spent ${formatCurrency(c.spent)} of ${formatCurrency(c.budget)}'),
          const SizedBox(height: 8),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: SizedBox(height: 10, child: LinearProgressIndicator(value: (pct / 100).clamp(0, 1), color: progressColor(pct).colors.first, backgroundColor: AppColors.brand50))),
          Text('${pct.toStringAsFixed(0)}% utilized'),
          if (_editingId == c.id)
            FormSection(
              children: [
                TextField(controller: _budgetCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'New Budget')),
                Row(
                  children: [
                    Expanded(child: ElevatedButton(onPressed: () async {
                      await dataStore.updateCampaign(c.id, {'budget': double.tryParse(_budgetCtrl.text) ?? c.budget}, context.read<AuthProvider>().user?.name ?? 'System');
                      setState(() => _editingId = null);
                      showToast(context, 'Budget updated');
                    }, child: const Text('Save'))),
                    const SizedBox(width: 8),
                    OutlinedButton(onPressed: () => setState(() => _editingId = null), child: const Text('Cancel')),
                  ],
                ),
              ],
            )
          else
            TextButton(onPressed: () { _budgetCtrl.text = c.budget.toStringAsFixed(0); setState(() => _editingId = c.id); }, child: const Text('Edit Budget')),
        ]));
      }),
    ]);
  }
}
