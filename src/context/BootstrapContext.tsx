import { createContext, useContext, useEffect, useState, useCallback, useRef, type ReactNode } from 'react';
import { hydrateDataStore, reloadCache } from '../data/dataStore';
import { loadDemoAccounts } from '../data/userStore';
import { SYNC_INTERVAL_MS } from '../config/api';

interface BootstrapContextType {
  ready: boolean;
  error: string | null;
  lastSyncedAt: Date | null;
  retry: () => void;
  silentSync: () => Promise<void>;
}

const BootstrapContext = createContext<BootstrapContextType | null>(null);

export function BootstrapProvider({ children }: { children: ReactNode }) {
  const [ready, setReady] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [lastSyncedAt, setLastSyncedAt] = useState<Date | null>(null);
  const syncingRef = useRef(false);

  const load = useCallback(async () => {
    setError(null);
    setReady(false);
    try {
      await hydrateDataStore();
      await loadDemoAccounts();
      setLastSyncedAt(new Date());
      setReady(true);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to connect to database');
    }
  }, []);

  const silentSync = useCallback(async () => {
    if (syncingRef.current) return;
    syncingRef.current = true;
    try {
      await reloadCache();
      setLastSyncedAt(new Date());
      setError(null);
    } catch {
      /* keep last good cache on background sync failure */
    } finally {
      syncingRef.current = false;
    }
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  /* Periodic sync — changes on mobile appear on web and vice versa */
  useEffect(() => {
    if (!ready) return;
    const id = setInterval(() => silentSync(), SYNC_INTERVAL_MS);
    return () => clearInterval(id);
  }, [ready, silentSync]);

  /* Sync when tab regains focus */
  useEffect(() => {
    const onVisible = () => {
      if (document.visibilityState === 'visible') silentSync();
    };
    document.addEventListener('visibilitychange', onVisible);
    return () => document.removeEventListener('visibilitychange', onVisible);
  }, [silentSync]);

  if (error) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-diamond-surface p-6">
        <div className="card max-w-md text-center">
          <h1 className="text-xl font-bold text-slate-900">Database Connection</h1>
          <p className="mt-2 text-sm text-slate-500">Could not load data from Prisma Postgres.</p>
          <p className="alert-error mt-4">{error}</p>
          <p className="mt-3 text-xs text-slate-400">
            Ensure the API server is running: <code className="font-mono">npm run server</code>
            <br />
            Web and mobile share the same Prisma database via <code className="font-mono">/api/sync</code>
          </p>
          <button onClick={load} className="btn-primary mt-6 w-full">Retry Connection</button>
        </div>
      </div>
    );
  }

  if (!ready) {
    return (
      <div className="flex min-h-screen flex-col items-center justify-center gap-4 bg-diamond-surface">
        <div className="h-12 w-12 animate-spin rounded-full border-4 border-brand-200 border-t-brand-600" />
        <p className="text-sm font-semibold text-brand-700">Connecting to Prisma database…</p>
      </div>
    );
  }

  return (
    <BootstrapContext.Provider value={{ ready, error, lastSyncedAt, retry: load, silentSync }}>
      {children}
    </BootstrapContext.Provider>
  );
}

export function useBootstrap() {
  const ctx = useContext(BootstrapContext);
  if (!ctx) throw new Error('useBootstrap must be used within BootstrapProvider');
  return ctx;
}
