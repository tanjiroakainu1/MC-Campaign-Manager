import { useState, useEffect } from 'react';
import { useAuth } from '../../context/AuthContext';
import PageHeader from '../../components/common/PageHeader';
import Toast from '../../components/common/Toast';
import DeveloperCredit from '../../components/DeveloperCredit';
import { getSettings, updateSettings, subscribeDataStore } from '../../data/dataStore';
import type { SystemSettings as SystemSettingsType } from '../../types';

export default function SystemSettings() {
  const { user } = useAuth();
  const [settings, setSettings] = useState<SystemSettingsType>(getSettings());
  const [toast, setToast] = useState('');
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    setSettings(getSettings());
    return subscribeDataStore(() => setSettings(getSettings()));
  }, []);

  const handleSave = async () => {
    setSaving(true);
    try {
      await updateSettings(settings, user?.name ?? 'System');
      setToast('System settings saved to database');
    } catch {
      setToast('Failed to save settings');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div>
      <PageHeader title="System Settings" description="Configure global system preferences — stored in Prisma Postgres" />

      <div className="space-y-6">
        <div className="card">
          <h2 className="section-title mb-4">General Settings</h2>
          <div className="form-grid">
            <div>
              <label className="label">Company Name</label>
              <input className="input-field" value={settings.companyName} onChange={(e) => setSettings({ ...settings, companyName: e.target.value })} />
            </div>
            <div>
              <label className="label">Timezone</label>
              <select className="input-field" value={settings.timezone} onChange={(e) => setSettings({ ...settings, timezone: e.target.value })}>
                <option value="America/New_York">Eastern Time</option>
                <option value="America/Chicago">Central Time</option>
                <option value="America/Los_Angeles">Pacific Time</option>
                <option value="Asia/Manila">Asia/Manila</option>
                <option value="UTC">UTC</option>
              </select>
            </div>
            <div>
              <label className="label">Currency</label>
              <select className="input-field" value={settings.currency} onChange={(e) => setSettings({ ...settings, currency: e.target.value })}>
                <option value="PHP">PHP (₱)</option>
                <option value="USD">USD ($)</option>
                <option value="EUR">EUR (€)</option>
                <option value="GBP">GBP (£)</option>
              </select>
            </div>
            <div>
              <label className="label">Session Timeout (minutes)</label>
              <input className="input-field" type="number" value={settings.sessionTimeout} onChange={(e) => setSettings({ ...settings, sessionTimeout: e.target.value })} />
            </div>
          </div>
        </div>

        <div className="card">
          <h2 className="section-title mb-4">Notifications</h2>
          <div className="space-y-3">
            <label className="flex items-center gap-3">
              <input type="checkbox" checked={settings.emailNotifications} onChange={(e) => setSettings({ ...settings, emailNotifications: e.target.checked })} className="h-4 w-4 rounded border-slate-300 text-brand-600" />
              <span className="text-sm text-slate-700">Enable email notifications</span>
            </label>
            <label className="flex items-center gap-3">
              <input type="checkbox" checked={settings.smsNotifications} onChange={(e) => setSettings({ ...settings, smsNotifications: e.target.checked })} className="h-4 w-4 rounded border-slate-300 text-brand-600" />
              <span className="text-sm text-slate-700">Enable SMS notifications</span>
            </label>
          </div>
        </div>

        <div className="card">
          <h2 className="section-title mb-4">Backup & Security</h2>
          <div className="form-grid">
            <label className="flex items-center gap-3">
              <input type="checkbox" checked={settings.autoBackup} onChange={(e) => setSettings({ ...settings, autoBackup: e.target.checked })} className="h-4 w-4 rounded border-slate-300 text-brand-600" />
              <span className="text-sm text-slate-700">Automatic backups</span>
            </label>
            <div>
              <label className="label">Backup Frequency</label>
              <select className="input-field" value={settings.backupFrequency} onChange={(e) => setSettings({ ...settings, backupFrequency: e.target.value })}>
                <option value="hourly">Hourly</option>
                <option value="daily">Daily</option>
                <option value="weekly">Weekly</option>
              </select>
            </div>
            <div>
              <label className="label">Max Upload Size (MB)</label>
              <input className="input-field" type="number" value={settings.maxUploadSize} onChange={(e) => setSettings({ ...settings, maxUploadSize: e.target.value })} />
            </div>
          </div>
        </div>

        <DeveloperCredit variant="card" />

        <div className="form-actions">
          <button onClick={handleSave} disabled={saving} className="btn-primary">{saving ? 'Saving…' : 'Save Settings'}</button>
        </div>
      </div>

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
