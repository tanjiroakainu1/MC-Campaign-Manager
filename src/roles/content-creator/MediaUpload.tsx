import { useState, useRef } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Toast from '../../components/common/Toast';
import { getMedia, addMedia, deleteMedia } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';

export default function MediaUpload() {
  const { user } = useAuth();
  const [media, setMedia] = useState(getMedia);
  const [toast, setToast] = useState('');
  const [dragOver, setDragOver] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const refresh = () => setMedia(getMedia());

  const handleFiles = async (files: FileList | null) => {
    if (!files || !user) return;
    await Promise.all(
      Array.from(files).map(async (f) => {
        let fileData: string | undefined;
        if (f.size <= 2 * 1024 * 1024) {
          fileData = await new Promise<string>((resolve) => {
            const reader = new FileReader();
            reader.onload = () => resolve((reader.result as string).split(',')[1] ?? '');
            reader.readAsDataURL(f);
          });
        }
        return addMedia({
          name: f.name,
          type: f.type,
          size: `${(f.size / 1024 / 1024).toFixed(1)} MB`,
          uploadedAt: new Date().toISOString().split('T')[0],
          uploadedBy: user.id,
          ...(fileData ? { fileData } : {}),
        }, user.name);
      })
    );
    refresh();
    setToast(`${files.length} file(s) uploaded to database`);
  };

  const handleDelete = async (id: string) => {
    await deleteMedia(id);
    refresh();
    setToast('File deleted');
  };

  return (
    <div>
      <PageHeader title="Upload Media" description="Upload images and videos to the media library" />

      <div
        className={`card-hover mb-6 border-2 border-dashed text-center transition-all duration-300 ${dragOver ? 'border-brand-500 bg-brand-50/80 scale-[1.01]' : 'border-brand-200'}`}
        onDragOver={(e) => { e.preventDefault(); setDragOver(true); }}
        onDragLeave={() => setDragOver(false)}
        onDrop={(e) => { e.preventDefault(); setDragOver(false); handleFiles(e.dataTransfer.files); }}
      >
        <div className="py-8">
          <p className="text-slate-600">Drag and drop files here, or</p>
          <button type="button" onClick={() => fileInputRef.current?.click()} className="btn-primary mt-3">Browse Files</button>
          <input ref={fileInputRef} type="file" multiple className="hidden" onChange={(e) => handleFiles(e.target.files)} accept="image/*,video/*" />
        </div>
      </div>

      <div className="card">
        <h2 className="section-title mb-4">Media Library ({media.length})</h2>
        <div className="action-grid">
          {media.map((file) => (
            <div key={file.id} className="card-hover group overflow-hidden p-0">
              <div className="flex h-28 items-center justify-center bg-gradient-to-br from-slate-50 to-slate-100 text-3xl transition group-hover:from-brand-50 group-hover:to-brand-100 sm:h-32">
                {file.type.startsWith('video') ? '🎬' : '🖼️'}
              </div>
              <div className="p-4">
              <p className="truncate text-sm font-bold text-slate-900">{file.name}</p>
              <p className="text-xs text-slate-500">{file.size} — {file.uploadedAt}</p>
              <button onClick={() => handleDelete(file.id)} className="btn-link-danger mt-2">Delete</button>
              </div>
            </div>
          ))}
        </div>
        {media.length === 0 && <p className="text-sm text-slate-500">No media uploaded yet.</p>}
      </div>

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
