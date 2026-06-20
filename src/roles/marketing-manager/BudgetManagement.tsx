import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Toast from '../../components/common/Toast';
import { getCampaigns, updateCampaign } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';
import { PROGRESS_COLORS } from '../../config/theme';
import { CURRENCY_SYMBOL, formatCurrency } from '../../config/currency';

export default function BudgetManagement() {
  const { user } = useAuth();
  const [campaigns, setCampaigns] = useState(getCampaigns);
  const [toast, setToast] = useState('');
  const [editingId, setEditingId] = useState<string | null>(null);
  const [newBudget, setNewBudget] = useState('');

  const refresh = () => setCampaigns(getCampaigns());
  const actor = user?.name ?? 'System';

  const startEdit = (id: string, current: number) => {
    setEditingId(id);
    setNewBudget(String(current));
  };

  const saveBudget = async (id: string) => {
    await updateCampaign(id, { budget: Number(newBudget) }, actor);
    refresh();
    setEditingId(null);
    setToast('Budget updated successfully');
  };

  return (
    <div>
      <PageHeader title="Budget Management" description="Set and monitor campaign budgets" />

      <div className="space-y-4">
        {campaigns.map((campaign) => {
          const utilization = campaign.budget ? Math.round((campaign.spent / campaign.budget) * 100) : 0;
          return (
            <div key={campaign.id} className="card-hover">
              <div className="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
                <div className="min-w-0 flex-1">
                  <h3 className="truncate text-base font-bold text-slate-900 sm:text-lg">{campaign.name}</h3>
                  <div className="mt-2 flex flex-wrap gap-x-4 gap-y-1 text-sm text-slate-500">
                    <span>Spent: <strong className="text-slate-700">{formatCurrency(campaign.spent)}</strong></span>
                    {editingId === campaign.id ? (
                      <div className="btn-group w-full pt-0 sm:w-auto">
                        <span>Budget: {CURRENCY_SYMBOL}</span>
                        <input className="input-field w-full max-w-[140px]" type="number" value={newBudget} onChange={(e) => setNewBudget(e.target.value)} />
                        <button onClick={() => saveBudget(campaign.id)} className="btn-primary text-sm">Save</button>
                        <button onClick={() => setEditingId(null)} className="btn-secondary text-sm">Cancel</button>
                      </div>
                    ) : (
                      <span>Budget: <strong className="text-slate-700">{formatCurrency(campaign.budget)}</strong></span>
                    )}
                  </div>
                  <div className="progress-bar mt-3">
                    <div
                      className={`progress-fill ${utilization > 80 ? PROGRESS_COLORS.danger : utilization > 50 ? PROGRESS_COLORS.medium : PROGRESS_COLORS.high}`}
                      style={{ width: `${Math.min(utilization, 100)}%` }}
                    />
                  </div>
                  <p className="mt-1.5 text-xs font-semibold text-slate-400">{utilization}% utilized</p>
                </div>
                {editingId !== campaign.id && (
                  <button onClick={() => startEdit(campaign.id, campaign.budget)} className="btn-secondary w-full sm:w-auto">Edit Budget</button>
                )}
              </div>
            </div>
          );
        })}
      </div>

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
