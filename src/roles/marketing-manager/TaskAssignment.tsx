import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Toast from '../../components/common/Toast';
import { getCampaigns, getTasks, addTask, updateTask } from '../../data/dataStore';
import { getAllUsers } from '../../data/userStore';
import { useAuth } from '../../context/AuthContext';
import type { Task } from '../../data/dataStore';

export default function TaskAssignment() {
  const { user } = useAuth();
  const [tasks, setTasks] = useState(getTasks);
  const [toast, setToast] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState({ title: '', campaignId: '', assigneeId: '', dueDate: '' });

  const campaigns = getCampaigns();
  const users = getAllUsers();
  const creators = users.filter((u) => u.role === 'content-creator' && u.status === 'active');

  const refresh = () => setTasks(getTasks());
  const actor = user?.name ?? 'System';

  const handleAssign = async (e: React.FormEvent) => {
    e.preventDefault();
    await addTask({ ...form, status: 'todo' }, actor);
    setForm({ title: '', campaignId: '', assigneeId: '', dueDate: '' });
    setShowForm(false);
    refresh();
    setToast('Task assigned successfully');
  };

  const updateStatus = async (id: string, status: Task['status']) => {
    await updateTask(id, { status });
    refresh();
    setToast('Task status updated');
  };

  const getCampaignName = (id: string) => campaigns.find((c) => c.id === id)?.name ?? 'Unknown';
  const getUserName = (id: string) => users.find((u) => u.id === id)?.name ?? 'Unknown';

  return (
    <div>
      <PageHeader
        title="Task Assignment"
        description="Assign campaign tasks to team members"
        action={<button onClick={() => setShowForm(!showForm)} className="btn-primary">Assign New Task</button>}
      />

      {showForm && (
        <form onSubmit={handleAssign} className="card mb-6 space-y-4">
          <div>
            <label className="label">Task Title</label>
            <input className="input-field" value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} required />
          </div>
          <div className="form-grid-3">
            <div>
              <label className="label">Campaign</label>
              <select className="input-field" value={form.campaignId} onChange={(e) => setForm({ ...form, campaignId: e.target.value })} required>
                <option value="">Select</option>
                {campaigns.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
              </select>
            </div>
            <div>
              <label className="label">Assign To</label>
              <select className="input-field" value={form.assigneeId} onChange={(e) => setForm({ ...form, assigneeId: e.target.value })} required>
                <option value="">Select</option>
                {creators.map((u) => <option key={u.id} value={u.id}>{u.name}</option>)}
              </select>
            </div>
            <div>
              <label className="label">Due Date</label>
              <input className="input-field" type="date" value={form.dueDate} onChange={(e) => setForm({ ...form, dueDate: e.target.value })} required />
            </div>
          </div>
          <div className="form-actions">
            <button type="submit" className="btn-primary">Assign Task</button>
          </div>
        </form>
      )}

      <div className="space-y-3">
        {tasks.map((task) => (
          <div key={task.id} className="card flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <p className="font-medium text-slate-900">{task.title}</p>
              <p className="text-xs text-slate-500">{getCampaignName(task.campaignId)} — Assigned to {getUserName(task.assigneeId)} — Due {task.dueDate}</p>
            </div>
            <select className="input-field w-auto" value={task.status} onChange={(e) => updateStatus(task.id, e.target.value as Task['status'])}>
              <option value="todo">To Do</option>
              <option value="in-progress">In Progress</option>
              <option value="done">Done</option>
            </select>
          </div>
        ))}
        {tasks.length === 0 && <p className="text-sm text-slate-500">No tasks assigned yet.</p>}
      </div>

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
