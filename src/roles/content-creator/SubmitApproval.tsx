import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Toast from '../../components/common/Toast';
import { getContentByUser, updateContent } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';
import { STATUS_BADGES } from '../../config/theme';

export default function SubmitApproval() {
  const { user } = useAuth();
  const [content, setContent] = useState(() =>
    user ? getContentByUser(user.id).filter((c) => c.status === 'draft' || c.status === 'pending') : []
  );
  const [toast, setToast] = useState('');
  const [selected, setSelected] = useState<string[]>([]);

  const refresh = () => {
    if (user) setContent(getContentByUser(user.id).filter((c) => c.status === 'draft' || c.status === 'pending'));
  };

  const toggleSelect = (id: string) => {
    setSelected(selected.includes(id) ? selected.filter((s) => s !== id) : [...selected, id]);
  };

  const submitSelected = async () => {
    await Promise.all(selected.map((id) => updateContent(id, { status: 'pending' }, user?.name)));
    refresh();
    setToast(`${selected.length} item(s) submitted for approval`);
    setSelected([]);
  };

  const drafts = content.filter((c) => c.status === 'draft');
  const pending = content.filter((c) => c.status === 'pending');

  return (
    <div>
      <PageHeader
        title="Submit for Approval"
        description="Submit content for manager review and approval"
        action={selected.length > 0 && <button onClick={submitSelected} className="btn-primary">Submit {selected.length} Selected</button>}
      />

      {drafts.length > 0 && (
        <div className="card mb-6">
          <h2 className="section-title mb-4">Ready to Submit ({drafts.length})</h2>
          <div className="space-y-3">
            {drafts.map((item) => (
              <label key={item.id} className="list-item cursor-pointer items-center gap-3 hover:bg-brand-50/40">
                <input type="checkbox" checked={selected.includes(item.id)} onChange={() => toggleSelect(item.id)} className="h-4 w-4 rounded border-slate-300 text-brand-600" />
                <div>
                  <p className="font-medium text-slate-900">{item.title}</p>
                  <p className="text-xs text-slate-500 capitalize">{item.type}</p>
                </div>
              </label>
            ))}
          </div>
        </div>
      )}

      <div className="card">
        <h2 className="section-title mb-4">Pending Approval ({pending.length})</h2>
        {pending.length === 0 ? (
          <p className="text-sm text-slate-500">No content pending approval</p>
        ) : (
          <div className="space-y-3">
            {pending.map((item) => (
              <div key={item.id} className="list-item border-diamond-200 bg-diamond-50">
                <div>
                  <p className="font-medium text-slate-900">{item.title}</p>
                  <p className="text-xs text-slate-500 capitalize">{item.type} — Awaiting review</p>
                </div>
                <span className={`badge ${STATUS_BADGES.pending}`}>Pending</span>
              </div>
            ))}
          </div>
        )}
      </div>

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
