interface ToastProps {
  message: string;
  type?: 'success' | 'error' | 'info';
  onClose: () => void;
}

export default function Toast({ message, type = 'success', onClose }: ToastProps) {
  const colors = {
    success: 'border-brand-200 bg-brand-50 text-brand-800',
    error: 'border-red-200 bg-red-50 text-red-800',
    info: 'border-diamond-200 bg-diamond-50 text-diamond-800',
  };

  const icons = {
    success: '✓',
    error: '!',
    info: 'i',
  };

  return (
    <div
      className={`fixed bottom-4 left-4 right-4 z-[60] mx-auto flex max-w-md animate-slide-up items-center gap-3 rounded-2xl border px-4 py-3.5 shadow-card-hover safe-bottom sm:left-auto sm:right-6 ${colors[type]}`}
      role="status"
    >
      <span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-white/80 text-sm font-bold">
        {icons[type]}
      </span>
      <span className="flex-1 text-sm font-semibold">{message}</span>
      <button onClick={onClose} className="btn-icon h-8 w-8 shrink-0 border-0 shadow-none" aria-label="Dismiss">
        <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    </div>
  );
}
