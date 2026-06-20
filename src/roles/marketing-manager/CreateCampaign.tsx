import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Toast from '../../components/common/Toast';
import { getCategories, addCampaign } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';
import { BUDGET_LABEL } from '../../config/currency';

export default function CreateCampaign() {
  const { user } = useAuth();
  const categories = getCategories();
  const [toast, setToast] = useState('');
  const [form, setForm] = useState({
    name: '',
    category: '',
    description: '',
    budget: '',
    startDate: '',
    endDate: '',
    channels: [] as string[],
  });

  const channelOptions = ['social', 'email', 'sms', 'ads'];

  const toggleChannel = (ch: string) => {
    setForm({
      ...form,
      channels: form.channels.includes(ch)
        ? form.channels.filter((c) => c !== ch)
        : [...form.channels, ch],
    });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await addCampaign({
      name: form.name,
      category: form.category,
      description: form.description,
      budget: Number(form.budget),
      spent: 0,
      startDate: form.startDate,
      endDate: form.endDate,
      channels: form.channels,
      managerId: user?.id ?? '',
      status: 'draft',
    }, user?.name);
    setToast(`Campaign "${form.name}" created successfully`);
    setForm({ name: '', category: '', description: '', budget: '', startDate: '', endDate: '', channels: [] });
  };

  return (
    <div>
      <PageHeader title="Create Campaign" description="Set up a new marketing campaign" />

      <form onSubmit={handleSubmit} className="card max-w-2xl space-y-4 lg:max-w-3xl">
        <div>
          <label className="label">Campaign Name</label>
          <input className="input-field" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} required />
        </div>
        <div>
          <label className="label">Category</label>
          <select className="input-field" value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value })} required>
            <option value="">Select category</option>
            {categories.map((c) => (
              <option key={c.id} value={c.name}>{c.name}</option>
            ))}
          </select>
        </div>
        <div>
          <label className="label">Description</label>
          <textarea className="input-field" rows={3} value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} />
        </div>
        <div className="form-grid">
          <div>
            <label className="label">{BUDGET_LABEL}</label>
            <input className="input-field" type="number" value={form.budget} onChange={(e) => setForm({ ...form, budget: e.target.value })} required />
          </div>
          <div>
            <label className="label">Channels</label>
            <div className="flex flex-wrap gap-2 pt-1">
              {channelOptions.map((ch) => (
                <button
                  key={ch}
                  type="button"
                  onClick={() => toggleChannel(ch)}
                  className={`badge cursor-pointer capitalize transition ${
                    form.channels.includes(ch) ? 'bg-brand-100 text-brand-800' : 'bg-slate-100 text-slate-600'
                  }`}
                >
                  {ch}
                </button>
              ))}
            </div>
          </div>
        </div>
        <div className="form-grid">
          <div>
            <label className="label">Start Date</label>
            <input className="input-field" type="date" value={form.startDate} onChange={(e) => setForm({ ...form, startDate: e.target.value })} required />
          </div>
          <div>
            <label className="label">End Date</label>
            <input className="input-field" type="date" value={form.endDate} onChange={(e) => setForm({ ...form, endDate: e.target.value })} required />
          </div>
        </div>
        <div className="form-actions">
          <button type="submit" className="btn-primary">Create Campaign</button>
        </div>
      </form>

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
