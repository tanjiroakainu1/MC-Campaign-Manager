import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Modal from '../../components/common/Modal';
import Toast from '../../components/common/Toast';
import { getStrategies, addStrategy, updateStrategy } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';
import { STATUS_BADGES } from '../../config/theme';

export default function MarketingStrategies() {
  const { user } = useAuth();
  const [strategies, setStrategies] = useState(getStrategies);
  const [modalOpen, setModalOpen] = useState(false);
  const [toast, setToast] = useState('');
  const [form, setForm] = useState({ name: '', description: '', channels: [] as string[] });

  const channelOptions = ['social', 'email', 'sms', 'ads'];
  const refresh = () => setStrategies(getStrategies());
  const actor = user?.name ?? 'System';

  const toggleChannel = (ch: string) => {
    setForm({
      ...form,
      channels: form.channels.includes(ch) ? form.channels.filter((c) => c !== ch) : [...form.channels, ch],
    });
  };

  const handleCreate = async () => {
    await addStrategy({ ...form, status: 'draft' }, actor);
    setForm({ name: '', description: '', channels: [] });
    setModalOpen(false);
    refresh();
    setToast('Strategy created');
  };

  const toggleStatus = async (id: string) => {
    const strategy = strategies.find((s) => s.id === id);
    if (strategy) {
      await updateStrategy(id, { status: strategy.status === 'active' ? 'draft' : 'active' });
      refresh();
      setToast('Strategy status updated');
    }
  };

  return (
    <div>
      <PageHeader title="Marketing Strategies" description="Define and manage marketing strategies" action={<button onClick={() => setModalOpen(true)} className="btn-primary">New Strategy</button>} />

      <div className="content-grid">
        {strategies.map((strategy) => (
          <div key={strategy.id} className="card-hover">
            <div className="flex items-start justify-between">
              <div>
                <h3 className="font-semibold text-slate-900">{strategy.name}</h3>
                <p className="mt-1 text-sm text-slate-500">{strategy.description}</p>
                <div className="mt-2 flex gap-1">
                  {strategy.channels.map((ch) => (
                    <span key={ch} className="badge bg-slate-100 text-slate-600 capitalize">{ch}</span>
                  ))}
                </div>
              </div>
              <span className={`badge ${strategy.status === 'active' ? STATUS_BADGES.active : STATUS_BADGES.draft}`}>{strategy.status}</span>
            </div>
            <button onClick={() => toggleStatus(strategy.id)} className="btn-link mt-4">
              {strategy.status === 'active' ? 'Set to Draft' : 'Activate'}
            </button>
          </div>
        ))}
      </div>

      <Modal isOpen={modalOpen} onClose={() => setModalOpen(false)} title="New Strategy">
        <div className="space-y-4">
          <div><label className="label">Name</label><input className="input-field" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} /></div>
          <div><label className="label">Description</label><textarea className="input-field" rows={3} value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} /></div>
          <div>
            <label className="label">Channels</label>
            <div className="flex flex-wrap gap-2">
              {channelOptions.map((ch) => (
                <button key={ch} type="button" onClick={() => toggleChannel(ch)} className={`badge cursor-pointer capitalize ${form.channels.includes(ch) ? 'bg-brand-100 text-brand-800' : 'bg-slate-100 text-slate-600'}`}>{ch}</button>
              ))}
            </div>
          </div>
          <div className="btn-group">
            <button onClick={() => setModalOpen(false)} className="btn-secondary">Cancel</button>
            <button onClick={handleCreate} className="btn-primary">Create</button>
          </div>
        </div>
      </Modal>

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
