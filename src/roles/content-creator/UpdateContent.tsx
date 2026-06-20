import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Modal from '../../components/common/Modal';
import Toast from '../../components/common/Toast';
import { getContentByUser, updateContent } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';
import type { Content } from '../../types';

export default function UpdateContent() {
  const { user } = useAuth();
  const [content, setContent] = useState(() => (user ? getContentByUser(user.id) : []));
  const [editing, setEditing] = useState<Content | null>(null);
  const [title, setTitle] = useState('');
  const [toast, setToast] = useState('');

  const refresh = () => { if (user) setContent(getContentByUser(user.id)); };

  const openEdit = (item: Content) => {
    setEditing(item);
    setTitle(item.title);
  };

  const handleSave = async () => {
    if (editing) {
      await updateContent(editing.id, { title }, user?.name);
      refresh();
      setToast('Content updated successfully');
      setEditing(null);
    }
  };

  const submitItem = async (id: string) => {
    await updateContent(id, { status: 'pending' }, user?.name);
    refresh();
    setToast('Submitted for approval');
  };

  return (
    <div>
      <PageHeader title="Update Content" description="Edit and update existing campaign content" />

      <div className="space-y-3">
        {content.length === 0 ? (
          <p className="text-sm text-slate-500">No content to update.</p>
        ) : (
          content.map((item) => (
            <div key={item.id} className="card flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
              <div>
                <p className="font-medium text-slate-900">{item.title}</p>
                <p className="text-xs text-slate-500 capitalize">{item.type} — {item.status}</p>
              </div>
              <div className="btn-group sm:w-auto">
                <button onClick={() => openEdit(item)} className="btn-secondary text-sm">Edit</button>
                {item.status === 'draft' && (
                  <button onClick={() => submitItem(item.id)} className="btn-primary text-sm">Submit</button>
                )}
              </div>
            </div>
          ))
        )}
      </div>

      <Modal isOpen={!!editing} onClose={() => setEditing(null)} title="Edit Content">
        <div className="space-y-4">
          <div><label className="label">Title</label><input className="input-field" value={title} onChange={(e) => setTitle(e.target.value)} /></div>
          <div className="btn-group">
            <button onClick={() => setEditing(null)} className="btn-secondary">Cancel</button>
            <button onClick={handleSave} className="btn-primary">Save Changes</button>
          </div>
        </div>
      </Modal>

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
