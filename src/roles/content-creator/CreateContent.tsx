import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Toast from '../../components/common/Toast';
import { getCampaigns, addContent } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';

export default function CreateContent() {
  const { user } = useAuth();
  const campaigns = getCampaigns();
  const [toast, setToast] = useState('');
  const [form, setForm] = useState({
    title: '',
    type: 'text' as 'image' | 'video' | 'text' | 'design',
    campaignId: '',
    body: '',
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await addContent({
      title: form.title,
      type: form.type,
      campaignId: form.campaignId,
      status: 'draft',
      createdBy: user?.id ?? '',
    }, user?.name);
    setToast(`Content "${form.title}" created as draft`);
    setForm({ title: '', type: 'text', campaignId: '', body: '' });
  };

  const handleSubmitApproval = async () => {
    if (!form.title || !form.campaignId) {
      setToast('Fill in title and campaign first');
      return;
    }
    await addContent({
      title: form.title,
      type: form.type,
      campaignId: form.campaignId,
      status: 'pending',
      createdBy: user?.id ?? '',
    }, user?.name);
    setToast('Content submitted for approval');
    setForm({ title: '', type: 'text', campaignId: '', body: '' });
  };

  return (
    <div>
      <PageHeader title="Create Content" description="Create new marketing content for campaigns" />

      <form onSubmit={handleSubmit} className="card max-w-2xl space-y-4 lg:max-w-3xl">
        <div>
          <label className="label">Content Title</label>
          <input className="input-field" value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} required />
        </div>
        <div className="form-grid">
          <div>
            <label className="label">Content Type</label>
            <select className="input-field" value={form.type} onChange={(e) => setForm({ ...form, type: e.target.value as typeof form.type })}>
              <option value="text">Text / Copy</option>
              <option value="image">Image</option>
              <option value="video">Video</option>
              <option value="design">Design</option>
            </select>
          </div>
          <div>
            <label className="label">Campaign</label>
            <select className="input-field" value={form.campaignId} onChange={(e) => setForm({ ...form, campaignId: e.target.value })} required>
              <option value="">Select campaign</option>
              {campaigns.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
            </select>
          </div>
        </div>
        <div>
          <label className="label">Content Body</label>
          <textarea className="input-field" rows={6} value={form.body} onChange={(e) => setForm({ ...form, body: e.target.value })} placeholder="Write your content here..." />
        </div>
        <div className="form-actions">
          <button type="submit" className="btn-primary">Save as Draft</button>
          <button type="button" onClick={handleSubmitApproval} className="btn-secondary">Submit for Approval</button>
        </div>
      </form>

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
