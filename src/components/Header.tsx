import { useState, useEffect, useRef } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useBootstrap } from '../context/BootstrapContext';
import { useSidebar } from '../context/SidebarContext';
import { ROLE_LABELS, ROLE_COLORS } from '../config/roles';
import { getNotifications, markNotificationRead } from '../data/dataStore';

export default function Header() {
  const { user, logout } = useAuth();
  const { silentSync, lastSyncedAt } = useBootstrap();
  const { toggle, isOpen, isCollapsed, isMobile, close } = useSidebar();
  const location = useLocation();
  const navigate = useNavigate();
  const [notifOpen, setNotifOpen] = useState(false);
  const headerRef = useRef<HTMLElement>(null);

  useEffect(() => {
    setNotifOpen(false);
  }, [location.pathname]);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (headerRef.current && !headerRef.current.contains(e.target as Node)) {
        setNotifOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  if (!user) return null;

  const notifications = getNotifications().filter((n) => !n.read);

  const handleLogout = () => {
    logout();
    navigate('/login');
    setNotifOpen(false);
    if (isMobile) close();
  };

  return (
    <header ref={headerRef} className="safe-top sticky top-0 z-20 border-b border-brand-100/80 bg-white/90 shadow-sm backdrop-blur-xl">
      <div className="flex h-14 items-center justify-between gap-2 px-3 sm:h-16 sm:gap-3 sm:px-6">
        <div className="flex min-w-0 items-center gap-2 sm:gap-3">
          <button
            onClick={toggle}
            className="sidebar-toggle"
            aria-label={isMobile ? (isOpen ? 'Close sidebar' : 'Open sidebar') : (isCollapsed ? 'Expand sidebar' : 'Collapse sidebar')}
            aria-expanded={isMobile ? isOpen : !isCollapsed}
          >
            <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              {isMobile && isOpen ? (
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              ) : (
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              )}
            </svg>
          </button>

          <div className="min-w-0 lg:hidden">
            <p className="truncate text-sm font-bold text-slate-900 sm:text-base">Campaign Manager</p>
            <span className={`badge mt-0.5 ${ROLE_COLORS[user.role]}`}>{ROLE_LABELS[user.role]}</span>
          </div>
        </div>

        <div className="flex shrink-0 items-center gap-1 sm:gap-2">
          <button
            onClick={() => silentSync()}
            className="btn-icon hidden sm:inline-flex"
            aria-label="Sync with database"
            title={lastSyncedAt ? `Last synced ${lastSyncedAt.toLocaleTimeString()}` : 'Sync with Prisma'}
          >
            <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
            </svg>
          </button>
          <div className="relative">
            <button
              onClick={() => setNotifOpen(!notifOpen)}
              className="btn-icon relative"
              aria-label="Notifications"
            >
              <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
              </svg>
              {notifications.length > 0 && (
                <span className="absolute right-1.5 top-1.5 flex h-4 w-4 items-center justify-center rounded-full bg-red-500 text-[10px] font-bold text-white">
                  {notifications.length > 9 ? '9+' : notifications.length}
                </span>
              )}
            </button>
            {notifOpen && (
              <div className="absolute right-0 z-50 mt-2 w-[min(20rem,calc(100vw-1.5rem))] animate-slide-down rounded-2xl border border-brand-100 bg-white py-2 shadow-card-hover">
                <p className="px-4 py-2 text-xs font-bold uppercase tracking-wider text-slate-400">Notifications</p>
                {notifications.length === 0 ? (
                  <p className="px-4 py-4 text-sm text-slate-500">No new notifications</p>
                ) : (
                  notifications.map((n) => (
                    <div
                      key={n.id}
                      className="cursor-pointer px-4 py-3 transition hover:bg-slate-50"
                      onClick={() => markNotificationRead(n.id)}
                    >
                      <p className="text-sm font-semibold text-slate-800">{n.title}</p>
                      <p className="mt-0.5 text-xs leading-relaxed text-slate-500">{n.message}</p>
                    </div>
                  ))
                )}
              </div>
            )}
          </div>

          <div className="hidden items-center gap-2 rounded-xl border border-brand-100 bg-brand-50/80 px-3 py-1.5 sm:flex">
            <div className="flex h-8 w-8 items-center justify-center rounded-full bg-gradient-to-br from-brand-200 to-diamond-300 text-sm font-bold text-brand-800">
              {user.name.charAt(0)}
            </div>
            <div className="hidden min-w-0 md:block">
              <p className="max-w-[140px] truncate text-sm font-semibold text-slate-800">{user.name}</p>
              <p className="max-w-[140px] truncate text-xs text-slate-500">{user.email}</p>
            </div>
          </div>

          <button
            onClick={handleLogout}
            className="btn-logout-icon sm:hidden"
            aria-label="Logout"
            title="Logout"
          >
            <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
            </svg>
          </button>

          <button
            onClick={handleLogout}
            className="btn-logout hidden sm:inline-flex"
            aria-label="Logout"
          >
            <svg className="h-4 w-4 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
            </svg>
            <span>Logout</span>
          </button>
        </div>
      </div>
    </header>
  );
}
