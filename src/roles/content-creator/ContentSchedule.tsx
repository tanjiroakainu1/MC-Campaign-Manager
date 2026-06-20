import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Toast from '../../components/common/Toast';
import { getContentByUser, updateContent } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';
import { STATUS_BADGES } from '../../config/theme';

export default function ContentSchedule() {
  const { user } = useAuth();
  const [content, setContent] = useState(() => (user ? getContentByUser(user.id) : []));
  const [toast, setToast] = useState('');

  const refresh = () => { if (user) setContent(getContentByUser(user.id)); };

  const scheduleContent = async (id: string, date: string) => {
    await updateContent(id, { scheduledDate: date }, user?.name);
    refresh();
    setToast('Content scheduled successfully');
  };

  const scheduled = content.filter((c) => c.scheduledDate);
  const unscheduled = content.filter((c) => !c.scheduledDate);

  return (
    <div>
      <PageHeader title="Content Schedule" description="Manage content publishing schedules" />

      <div className="mb-6 card">
        <h2 className="section-title mb-4">Scheduled Content ({scheduled.length})</h2>
        {scheduled.length === 0 ? (
          <p className="text-sm text-slate-500">No content scheduled yet</p>
        ) : (
          <div className="space-y-3">
            {scheduled.map((item) => (
              <div key={item.id} className="list-item">
                <div>
                  <p className="font-medium text-slate-900">{item.title}</p>
                  <p className="text-xs text-slate-500 capitalize">{item.type} — Scheduled for {item.scheduledDate}</p>
                </div>
                <span className={`badge capitalize ${item.status === 'approved' ? STATUS_BADGES.approved : STATUS_BADGES.pending}`}>{item.status}</span>
              </div>
            ))}
          </div>
        )}
      </div>

      <div className="card">
        <h2 className="section-title mb-4">Unscheduled Content</h2>
        {unscheduled.length === 0 ? (
          <p className="text-sm text-slate-500">All content is scheduled.</p>
        ) : (
          <div className="space-y-3">
            {unscheduled.map((item) => (
              <div key={item.id} className="list-item">
                <div>
                  <p className="font-medium text-slate-900">{item.title}</p>
                  <p className="text-xs text-slate-500 capitalize">{item.type}</p>
                </div>
                <input type="date" className="input-field w-auto" onChange={(e) => scheduleContent(item.id, e.target.value)} />
              </div>
            ))}
          </div>
        )}
      </div>

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
