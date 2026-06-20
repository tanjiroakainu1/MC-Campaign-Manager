import { DEVELOPER } from '../config/developer';

type DeveloperCreditVariant = 'hero' | 'footer-dark' | 'footer-light' | 'sidebar' | 'card' | 'inline';

interface DeveloperCreditProps {
  variant?: DeveloperCreditVariant;
  className?: string;
}

function DevIcon({ className = 'h-5 w-5' }: { className?: string }) {
  return (
    <svg className={className} fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
    </svg>
  );
}

export default function DeveloperCredit({ variant = 'inline', className = '' }: DeveloperCreditProps) {
  if (variant === 'hero') {
    return (
      <section id="developer" className={`scroll-mt-20 border-t border-white/10 px-4 py-16 sm:px-6 sm:py-20 lg:px-8 ${className}`}>
        <div className="mx-auto max-w-4xl">
          <div className="dev-credit-hero animate-scale-in overflow-hidden rounded-3xl border border-white/20 bg-white/95 p-8 shadow-glow sm:p-10">
            <div className="pointer-events-none absolute inset-0 dev-credit-mesh opacity-40" />

            <div className="relative flex flex-col items-center text-center">
              <div className="dev-avatar relative mb-6 flex h-20 w-20 items-center justify-center rounded-2xl bg-gradient-to-br from-brand-500 via-brand-600 to-diamond-400 text-2xl font-black text-white shadow-glow-diamond sm:h-24 sm:w-24 sm:text-3xl">
                <span className="relative z-10">{DEVELOPER.initials}</span>
                <div className="absolute -inset-1 rounded-2xl bg-gradient-to-br from-diamond-300 to-brand-400 opacity-40 blur-md" />
              </div>

              <p className="text-xs font-bold uppercase tracking-[0.25em] text-brand-600">Meet the Developer</p>
              <h2 className="dev-name-shimmer mt-3 text-3xl font-black tracking-tight text-slate-900 sm:text-4xl">
                {DEVELOPER.name}
              </h2>
              <p className="mt-2 text-base font-bold text-brand-600 sm:text-lg">{DEVELOPER.title}</p>
              <p className="mx-auto mt-4 max-w-lg text-sm leading-relaxed text-slate-600 sm:text-base">
                {DEVELOPER.tagline}. This entire Marketing Campaign Management System — every dashboard,
                role, sidebar, and pixel — was designed and built from the ground up.
              </p>

              <div className="mt-6 flex flex-wrap items-center justify-center gap-2">
                {DEVELOPER.stack.map((tech) => (
                  <span
                    key={tech}
                    className="rounded-full border border-brand-200/80 bg-brand-50 px-3.5 py-1.5 text-xs font-bold text-brand-700 shadow-sm"
                  >
                    {tech}
                  </span>
                ))}
              </div>

              <div className="mt-8 flex items-center gap-3 rounded-2xl border border-slate-200/80 bg-slate-50/80 px-5 py-3">
                <DevIcon className="h-5 w-5 text-brand-600" />
                <p className="font-mono text-sm font-semibold text-slate-700">
                  <span className="text-brand-600">{'{'}</span>
                  {' '}{DEVELOPER.role}: <span className="font-bold text-slate-900">{DEVELOPER.name}</span>{' '}
                  <span className="text-brand-600">{'}'}</span>
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>
    );
  }

  if (variant === 'footer-dark') {
    return (
      <div className={`dev-credit-footer-dark ${className}`}>
        <div className="flex items-center justify-center gap-2 sm:justify-start sm:gap-2.5">
          <div className="flex h-7 w-7 shrink-0 items-center justify-center rounded-lg bg-gradient-to-br from-brand-500 to-diamond-400 text-[10px] font-black text-white shadow-glow-sm">
            {DEVELOPER.initials}
          </div>
          <p className="text-xs font-semibold text-white sm:text-sm">
            <span className="text-brand-200">by</span>{' '}
            <span className="dev-name-glow">{DEVELOPER.name}</span>
            <span className="hidden text-brand-300 sm:inline"> · v{DEVELOPER.version}</span>
          </p>
        </div>
      </div>
    );
  }

  if (variant === 'footer-light') {
    return (
      <footer className={`dev-credit-footer-light safe-bottom border-t border-brand-100/80 bg-brand-50/50 px-4 py-4 backdrop-blur-sm sm:px-6 ${className}`}>
        <div className="mx-auto flex max-w-7xl flex-col items-center justify-between gap-3 text-center sm:flex-row sm:gap-4 sm:text-left">
          <div className="flex items-center gap-2.5">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-gradient-to-br from-brand-500 to-diamond-400 text-[10px] font-black text-white shadow-glow-sm">
              {DEVELOPER.initials}
            </div>
            <p className="text-xs font-semibold text-slate-500 sm:text-sm">
              Built by <span className="font-bold text-slate-800">{DEVELOPER.name}</span>
              <span className="mx-1.5 text-slate-300">·</span>
              <span className="text-brand-600">{DEVELOPER.role}</span>
            </p>
          </div>
          <p className="text-xs font-medium text-slate-400">
            © {DEVELOPER.year} Campaign Manager
          </p>
        </div>
      </footer>
    );
  }

  if (variant === 'sidebar') {
    return (
      <div className={`dev-credit-sidebar rounded-xl border border-brand-100 bg-gradient-to-br from-brand-50/80 to-diamond-50/60 p-2.5 ${className}`}>
        <div className="flex items-center gap-2">
          <div className="flex h-7 w-7 shrink-0 items-center justify-center rounded-lg bg-gradient-to-br from-brand-500 to-diamond-400 text-[9px] font-black text-white">
            {DEVELOPER.initials}
          </div>
          <div className="min-w-0">
            <p className="truncate text-[10px] font-bold uppercase tracking-wider text-brand-600">Developer</p>
            <p className="truncate text-xs font-bold text-slate-800">{DEVELOPER.name}</p>
          </div>
        </div>
      </div>
    );
  }

  if (variant === 'card') {
    return (
      <div className={`dev-credit-card card-hover overflow-hidden ${className}`}>
        <div className="flex flex-col gap-5 sm:flex-row sm:items-center sm:justify-between">
          <div className="flex items-center gap-4">
            <div className="relative flex h-16 w-16 shrink-0 items-center justify-center rounded-2xl bg-gradient-to-br from-brand-500 via-brand-600 to-diamond-400 text-xl font-black text-white shadow-glow-diamond">
              {DEVELOPER.initials}
              <div className="absolute -inset-0.5 rounded-2xl bg-gradient-to-br from-diamond-300 to-brand-400 opacity-30 blur-sm" />
            </div>
            <div>
              <p className="text-xs font-bold uppercase tracking-widest text-brand-600">System Developer</p>
              <h3 className="text-xl font-black text-slate-900">{DEVELOPER.name}</h3>
              <p className="mt-0.5 text-sm font-semibold text-slate-500">{DEVELOPER.title}</p>
            </div>
          </div>
          <div className="flex flex-wrap gap-2">
            {DEVELOPER.stack.map((tech) => (
              <span key={tech} className="badge bg-brand-100 text-brand-800">{tech}</span>
            ))}
          </div>
        </div>
        <p className="mt-4 text-sm leading-relaxed text-slate-600">{DEVELOPER.tagline}.</p>
        <div className="mt-4 flex flex-wrap items-center gap-3 rounded-xl bg-brand-50 px-4 py-3 text-sm">
          <DevIcon className="h-4 w-4 text-brand-600" />
          <span className="font-semibold text-slate-600">Version</span>
          <span className="badge bg-brand-100 text-brand-800">v{DEVELOPER.version}</span>
          <span className="text-brand-200">·</span>
          <span className="font-semibold text-slate-600">Theme</span>
          <span className="badge bg-diamond-100 text-diamond-800">Blue Diamond</span>
          <span className="text-brand-200">·</span>
          <span className="font-semibold text-slate-600">Status</span>
          <span className="badge bg-brand-200 text-brand-900">Production Ready</span>
        </div>
      </div>
    );
  }

  return (
    <span className={`inline-flex items-center gap-1.5 text-xs font-semibold text-slate-500 ${className}`}>
      <DevIcon className="h-3.5 w-3.5 text-brand-500" />
      {DEVELOPER.name} · {DEVELOPER.role}
    </span>
  );
}
