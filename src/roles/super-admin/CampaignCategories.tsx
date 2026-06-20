import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Modal from '../../components/common/Modal';
import Toast from '../../components/common/Toast';
import { getCategories, addCategory, updateCategory, deleteCategory } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';
import type { CampaignCategory } from '../../types';

export default function CampaignCategories() {
  const { user } = useAuth();
  const [categories, setCategories] = useState(getCategories);
  const [modalOpen, setModalOpen] = useState(false);
  const [editCat, setEditCat] = useState<CampaignCategory | null>(null);
  const [toast, setToast] = useState('');
  const [form, setForm] = useState({ name: '', description: '' });

  const refresh = () => setCategories(getCategories());
  const actor = user?.name ?? 'System';

  const openAdd = () => {
    setEditCat(null);
    setForm({ name: '', description: '' });
    setModalOpen(true);
  };

  const openEdit = (cat: CampaignCategory) => {
    setEditCat(cat);
    setForm({ name: cat.name, description: cat.description });
    setModalOpen(true);
  };

  const handleSave = async () => {
    if (editCat) {
      await updateCategory(editCat.id, form, actor);
      setToast('Category updated');
    } else {
      await addCategory(form, actor);
      setToast('Category created');
    }
    refresh();
    setModalOpen(false);
  };

  const handleDelete = async (id: string) => {
    await deleteCategory(id, actor);
    refresh();
    setToast('Category deleted');
  };

  return (
    <div>
      <PageHeader
        title="Campaign Categories"
        description="Manage campaign classification categories"
        action={<button onClick={openAdd} className="btn-primary">Add Category</button>}
      />

      <div className="action-grid">
        {categories.map((cat) => (
          <div key={cat.id} className="card-hover">
            <div className="flex items-start justify-between">
              <div>
                <h3 className="font-semibold text-slate-900">{cat.name}</h3>
                <p className="mt-1 text-sm text-slate-500">{cat.description}</p>
                <p className="mt-2 text-xs text-slate-400">{cat.campaignCount} campaigns</p>
              </div>
              <div className="flex gap-1">
                <button onClick={() => openEdit(cat)} className="btn-link">Edit</button>
                <button onClick={() => handleDelete(cat.id)} className="btn-link-danger">Delete</button>
              </div>
            </div>
          </div>
        ))}
      </div>

      <Modal isOpen={modalOpen} onClose={() => setModalOpen(false)} title={editCat ? 'Edit Category' : 'Add Category'}>
        <div className="space-y-4">
          <div>
            <label className="label">Name</label>
            <input className="input-field" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
          </div>
          <div>
            <label className="label">Description</label>
            <textarea className="input-field" rows={3} value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} />
          </div>
          <div className="btn-group">
            <button onClick={() => setModalOpen(false)} className="btn-secondary">Cancel</button>
            <button onClick={handleSave} className="btn-primary">Save</button>
          </div>
        </div>
      </Modal>

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
