import { useRef, useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Toast from '../../components/common/Toast';
import { addDesign, getDesignsByUser, addMedia, getDesignTemplates } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';
import { STATUS_BADGES } from '../../config/theme';

export default function DesignMaterials() {
  const { user } = useAuth();
  const templates = getDesignTemplates();
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [toast, setToast] = useState('');
  const [selectedTemplate, setSelectedTemplate] = useState<string | null>(null);
  const [chosenFile, setChosenFile] = useState<File | null>(null);
  const [savedDesigns, setSavedDesigns] = useState(() => (user ? getDesignsByUser(user.id) : []));

  const refreshSaved = () => {
    if (user) setSavedDesigns(getDesignsByUser(user.id));
  };

  const startDesign = (name: string) => {
    setSelectedTemplate(name);
    setChosenFile(null);
    setToast(`Opening design editor for "${name}"`);
  };

  const handleChooseFile = (files: FileList | null) => {
    if (!files?.[0]) return;
    const file = files[0];
    setChosenFile(file);
    setToast(`File selected: ${file.name}`);
  };

  const handleSaveDesign = async () => {
    if (!user || !selectedTemplate) return;

    const designName = chosenFile
      ? `${selectedTemplate} — ${chosenFile.name}`
      : selectedTemplate;

    if (chosenFile) {
      await addMedia({
        name: chosenFile.name,
        type: chosenFile.type,
        size: `${(chosenFile.size / 1024 / 1024).toFixed(1)} MB`,
        uploadedAt: new Date().toISOString().split('T')[0],
        uploadedBy: user.id,
      }, user.name);
    }

    await addDesign({
      name: designName,
      template: selectedTemplate,
      fileName: chosenFile?.name,
      fileType: chosenFile?.type,
      savedAt: new Date().toISOString(),
      createdBy: user.id,
      status: 'saved',
    }, user.name);

    refreshSaved();
    setToast(`Design saved: ${designName}`);
    setChosenFile(null);
    if (fileInputRef.current) fileInputRef.current.value = '';
  };

  return (
    <div>
      <PageHeader title="Design Materials" description="Design promotional materials using templates" />

      {selectedTemplate && (
        <div className="card mb-6">
          <h2 className="section-title mb-4">Design Editor — {selectedTemplate}</h2>
          <div className="flex min-h-[16rem] flex-col items-center justify-center rounded-xl border-2 border-dashed border-brand-200 bg-brand-50/50 p-6">
            {chosenFile ? (
              <div className="text-center">
                <p className="text-sm font-semibold text-brand-700">File attached</p>
                <p className="mt-1 text-slate-700">{chosenFile.name}</p>
                <p className="text-xs text-slate-500">{(chosenFile.size / 1024 / 1024).toFixed(2)} MB — {chosenFile.type || 'Unknown type'}</p>
              </div>
            ) : (
              <p className="text-slate-500">Canvas Preview Area — choose a file to add to your design</p>
            )}

            <input
              ref={fileInputRef}
              type="file"
              className="hidden"
              accept="image/*,.pdf,.svg"
              onChange={(e) => handleChooseFile(e.target.files)}
            />

            <div className="btn-group mt-4 justify-center sm:w-auto">
              <button type="button" onClick={() => fileInputRef.current?.click()} className="btn-secondary text-sm">
                Choose File
              </button>
              <button type="button" onClick={() => setToast('Text layer added to canvas')} className="btn-secondary text-sm">
                Add Text
              </button>
              <button type="button" onClick={handleSaveDesign} className="btn-primary text-sm">
                Saved
              </button>
              <button type="button" onClick={() => { setSelectedTemplate(null); setChosenFile(null); }} className="btn-ghost text-sm">
                Close
              </button>
            </div>
          </div>
        </div>
      )}

      {savedDesigns.length > 0 && (
        <div className="card mb-6">
          <h2 className="section-title mb-4">Saved Designs ({savedDesigns.length})</h2>
          <div className="space-y-3">
            {savedDesigns.map((design) => (
              <div key={design.id} className="list-item">
                <div>
                  <p className="font-medium text-slate-900">{design.name}</p>
                  <p className="text-xs text-slate-500">
                    {design.template}
                    {design.fileName ? ` — ${design.fileName}` : ''}
                    {' — '}
                    {new Date(design.savedAt).toLocaleString()}
                  </p>
                </div>
                <span className={`badge ${STATUS_BADGES.approved}`}>Saved</span>
              </div>
            ))}
          </div>
        </div>
      )}

      <div className="action-grid">
        {templates.map((template) => (
          <div key={template.id} className="card">
            <div className="flex h-32 items-center justify-center rounded-lg bg-gradient-to-br from-brand-50 to-diamond-100">
              <span className="text-sm text-slate-400">{template.size}</span>
            </div>
            <h3 className="mt-3 font-semibold text-slate-900">{template.name}</h3>
            <div className="mt-1 flex items-center gap-2">
              <span className="badge bg-slate-100 text-slate-600">{template.category}</span>
              <span className="text-xs text-slate-400">{template.size}</span>
            </div>
            <button onClick={() => startDesign(template.name)} className="btn-primary mt-3 w-full text-sm">Use Template</button>
          </div>
        ))}
      </div>

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
