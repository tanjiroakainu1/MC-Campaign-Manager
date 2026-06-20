import { useState } from 'react';
import { Link } from 'react-router-dom';
import DeveloperCredit from './DeveloperCredit';

interface PublicShellProps {
  children: React.ReactNode;
  active?: 'home' | 'login' | 'register';
  showFooter?: boolean;
}

const NAV_LINKS = [
  { href: '/#how-it-works', label: 'How It Works' },
  { href: '/#roles', label: 'Roles' },
  { href: '/#flow', label: 'Campaign Flow' },
  { href: '/#developer', label: 'Developer' },
];

export default function PublicShell({ children, active = 'home', showFooter = true }: PublicShellProps) {
  const [menuOpen, setMenuOpen] = useState(false);

  const closeMenu = () => setMenuOpen(false);

  return (
    <div className="relative min-h-screen overflow-x-hidden bg-diamond-gradient">
      <div className="pointer-events-none absolute inset-0 overflow-hidden">
        <div className="absolute -left-32 top-0 h-[28rem] w-[28rem] rounded-full bg-diamond-400/20 blur-3xl animate-diamond-pulse" />
        <div className="absolute -right-32 top-1/3 h-[32rem] w-[32rem] rounded-full bg-brand-400/15 blur-3xl" />
        <div className="absolute bottom-0 left-1/3 h-80 w-80 rounded-full bg-diamond-300/15 blur-3xl" />
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top,_rgba(125,220,255,0.12)_0%,_transparent_55%)]" />
      </div>

      <header className="safe-top sticky top-0 z-30 border-b border-diamond-400/20 bg-brand-950/75 backdrop-blur-xl">
        <div className="mx-auto flex h-14 max-w-7xl items-center justify-between gap-3 px-4 sm:h-16 sm:gap-4 sm:px-6 lg:px-8">
          <Link to="/" className="flex min-w-0 items-center gap-2.5 transition hover:opacity-90 sm:gap-3" onClick={closeMenu}>
            <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-gradient-to-br from-diamond-200 to-brand-400 text-sm font-bold text-brand-900 shadow-glow-sm sm:h-10 sm:w-10">
              MC
            </div>
            <div className="min-w-0">
              <p className="truncate text-sm font-bold text-white sm:text-base">Campaign Manager</p>
              <p className="hidden truncate text-xs text-diamond-200 xs:block">Blue Diamond Theme</p>
            </div>
          </Link>

          <nav className="hidden items-center gap-1 md:flex">
            {NAV_LINKS.map((link) => (
              <a key={link.href} href={link.href} className="btn-nav">{link.label}</a>
            ))}
          </nav>

          <div className="flex shrink-0 items-center gap-2">
            <Link
              to="/login"
              className={`hidden sm:inline-flex btn-nav ${active === 'login' ? 'btn-nav-active' : ''}`}
            >
              Sign In
            </Link>
            <Link to="/register" className="btn-primary btn-sm hidden shadow-button xs:inline-flex">
              Get Started
            </Link>

            <button
              type="button"
              onClick={() => setMenuOpen(!menuOpen)}
              className="btn-icon border-diamond-400/30 bg-white/10 text-white hover:border-diamond-300/50 hover:bg-white/15 hover:text-white md:hidden"
              aria-label={menuOpen ? 'Close menu' : 'Open menu'}
              aria-expanded={menuOpen}
            >
              <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                {menuOpen ? (
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                ) : (
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                )}
              </svg>
            </button>
          </div>
        </div>

        {menuOpen && (
          <>
            <div className="fixed inset-0 z-40 bg-brand-950/50 backdrop-blur-sm md:hidden" onClick={closeMenu} aria-hidden="true" />
            <nav className="safe-bottom relative z-50 animate-slide-down border-t border-diamond-400/20 bg-brand-950/95 px-4 py-4 backdrop-blur-xl md:hidden">
              <div className="flex flex-col gap-1">
                {NAV_LINKS.map((link) => (
                  <a key={link.href} href={link.href} onClick={closeMenu} className="btn-nav min-h-[48px] justify-start px-4">
                    {link.label}
                  </a>
                ))}
              </div>
              <div className="mt-4 flex flex-col gap-2 border-t border-diamond-400/20 pt-4">
                <Link to="/login" onClick={closeMenu} className="btn-glass w-full">Sign In</Link>
                <Link to="/register" onClick={closeMenu} className="btn-primary w-full shadow-button">Get Started</Link>
              </div>
            </nav>
          </>
        )}
      </header>

      <div className="relative">{children}</div>

      {showFooter && (
        <footer className="safe-bottom relative border-t border-white/10 bg-brand-950/40 backdrop-blur-sm">
          <div className="mx-auto max-w-7xl px-4 py-3 sm:px-6 lg:px-8">
            <div className="flex flex-col items-center gap-2 text-center sm:flex-row sm:items-center sm:justify-between sm:gap-3 sm:text-left">
              <p className="text-xs font-semibold text-brand-200">
                <span className="font-bold text-white">MC</span> Campaign Manager
              </p>

              <DeveloperCredit variant="footer-dark" />

              <div className="flex flex-wrap items-center justify-center gap-x-3 gap-y-1 text-xs">
                <Link to="/login" className="font-semibold text-brand-100 transition hover:text-white">
                  Sign In
                </Link>
                <Link to="/register" className="font-semibold text-brand-100 transition hover:text-white">
                  Register
                </Link>
                <span className="hidden text-brand-300/60 sm:inline">·</span>
                <span className="text-brand-300">4 Roles · One Platform</span>
              </div>
            </div>
          </div>
        </footer>
      )}
    </div>
  );
}
