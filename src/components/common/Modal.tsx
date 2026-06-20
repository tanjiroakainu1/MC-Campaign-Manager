import { useEffect, type ReactNode } from 'react';

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: ReactNode;
  size?: 'sm' | 'md' | 'lg';
}

export default function Modal({ isOpen, onClose, title, children, size = 'md' }: ModalProps) {
  useEffect(() => {
    const handleEsc = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
    };
    if (isOpen) {
      document.addEventListener('keydown', handleEsc);
      document.body.style.overflow = 'hidden';
    }
    return () => {
      document.removeEventListener('keydown', handleEsc);
      document.body.style.overflow = '';
    };
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  const sizeClass = { sm: 'max-w-md', md: 'max-w-lg', lg: 'max-w-2xl' }[size];

  return (
    <div className="safe-top safe-bottom fixed inset-0 z-50 flex items-end justify-center p-0 sm:items-center sm:p-4">
      <div className="absolute inset-0 bg-brand-950/60 backdrop-blur-md transition-opacity" onClick={onClose} />
      <div className={`relative max-h-[92dvh] w-full animate-scale-in overflow-y-auto rounded-t-3xl border border-brand-100 bg-white shadow-2xl sm:max-h-[90vh] sm:rounded-2xl ${sizeClass}`}>
        <div className="sticky top-0 z-10 flex items-center justify-between border-b border-brand-100 bg-white/95 px-4 py-4 backdrop-blur sm:px-6">
          <h2 className="pr-4 text-base font-bold tracking-tight text-slate-900 sm:text-lg">{title}</h2>
          <button onClick={onClose} className="btn-icon shrink-0" aria-label="Close">
            <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <div className="px-4 py-5 sm:px-6">{children}</div>
      </div>
    </div>
  );
}
