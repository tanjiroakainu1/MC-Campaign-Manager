import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Modal from '../../components/common/Modal';
import Toast from '../../components/common/Toast';
import { getAllUsers, addUser, updateUser, deleteUser as removeUser } from '../../data/userStore';
import { ROLE_LABELS, ROLE_COLORS } from '../../config/roles';
import { STATUS_BADGES } from '../../config/theme';
import type { User, UserRole } from '../../types';

export default function UserManagement() {
  const [users, setUsers] = useState(() =>
    [...getAllUsers()].sort((a, b) => b.createdAt.localeCompare(a.createdAt))
  );
  const [modalOpen, setModalOpen] = useState(false);
  const [editUser, setEditUser] = useState<User | null>(null);
  const [toast, setToast] = useState('');
  const [form, setForm] = useState({
    name: '',
    email: '',
    role: 'content-creator' as UserRole,
    status: 'active' as 'active' | 'inactive',
    password: '',
  });

  const refreshUsers = () =>
    setUsers([...getAllUsers()].sort((a, b) => b.createdAt.localeCompare(a.createdAt)));

  const openAdd = () => {
    setEditUser(null);
    setForm({ name: '', email: '', role: 'content-creator', status: 'active', password: '' });
    setModalOpen(true);
  };

  const openEdit = (user: User) => {
    setEditUser(user);
    setForm({ name: user.name, email: user.email, role: user.role, status: user.status, password: '' });
    setModalOpen(true);
  };

  const handleSave = async () => {
    if (editUser) {
      await updateUser(editUser.id, {
        name: form.name,
        email: form.email,
        role: form.role,
        status: form.status,
      });
      setToast('User updated successfully');
    } else {
      if (!form.password || form.password.length < 6) {
        setToast('Password must be at least 6 characters');
        return;
      }
      await addUser(
        { name: form.name, email: form.email, role: form.role, status: form.status },
        form.password
      );
      setToast('User created successfully — they can now log in');
    }
    refreshUsers();
    setModalOpen(false);
  };

  const toggleStatus = async (id: string) => {
    const user = users.find((u) => u.id === id);
    if (user) {
      await updateUser(id, { status: user.status === 'active' ? 'inactive' : 'active' });
      refreshUsers();
      setToast('User status updated');
    }
  };

  const deleteUser = async (id: string) => {
    await removeUser(id);
    refreshUsers();
    setToast('User deleted');
  };

  return (
    <div>
      <PageHeader
        title="User Management"
        description="All registered and admin-created users appear here — synced from Prisma in real time"
        action={<button onClick={openAdd} className="btn-primary">Add User</button>}
      />

      <div className="card overflow-hidden p-0 sm:p-0">
        <div className="table-wrap scrollbar-thin">
          <table className="data-table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Email</th>
              <th>Role</th>
              <th>Status</th>
              <th>Registered</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user) => (
              <tr key={user.id}>
                <td className="font-semibold text-slate-900">{user.name}</td>
                <td className="text-slate-500">{user.email}</td>
                <td>
                  <span className={`badge ${ROLE_COLORS[user.role]}`}>{ROLE_LABELS[user.role]}</span>
                </td>
                <td>
                  <span className={`badge ${user.status === 'active' ? STATUS_BADGES.active : STATUS_BADGES.inactive}`}>
                    {user.status}
                  </span>
                </td>
                <td className="text-slate-500 text-sm">{user.createdAt}</td>
                <td>
                  <div className="flex flex-wrap gap-1">
                    <button onClick={() => openEdit(user)} className="btn-link">Edit</button>
                    <button onClick={() => toggleStatus(user.id)} className="btn-link-muted">
                      {user.status === 'active' ? 'Deactivate' : 'Activate'}
                    </button>
                    <button onClick={() => deleteUser(user.id)} className="btn-link-danger">Delete</button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        </div>
      </div>

      <Modal isOpen={modalOpen} onClose={() => setModalOpen(false)} title={editUser ? 'Edit User' : 'Add User'}>
        <div className="space-y-4">
          <div className="form-grid">
            <div>
              <label className="label">Name</label>
              <input className="input-field" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
            </div>
            <div>
              <label className="label">Email</label>
              <input className="input-field" type="email" value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} />
            </div>
            <div>
              <label className="label">Role</label>
              <select className="input-field" value={form.role} onChange={(e) => setForm({ ...form, role: e.target.value as UserRole })}>
                {Object.entries(ROLE_LABELS).map(([key, label]) => (
                  <option key={key} value={key}>{label}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="label">Status</label>
              <select className="input-field" value={form.status} onChange={(e) => setForm({ ...form, status: e.target.value as 'active' | 'inactive' })}>
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
              </select>
            </div>
          </div>
          {!editUser && (
            <div>
              <label className="label">Password</label>
              <input
                className="input-field"
                type="password"
                value={form.password}
                onChange={(e) => setForm({ ...form, password: e.target.value })}
                placeholder="Min. 6 characters"
              />
            </div>
          )}
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
