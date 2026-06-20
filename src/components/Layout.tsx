import { useEffect, useState } from 'react';
import { Outlet, useLocation } from 'react-router-dom';
import { SidebarProvider, useSidebar } from '../context/SidebarContext';
import { subscribeDataStore } from '../data/dataStore';
import Sidebar from './Sidebar';
import Header from './Header';
import DeveloperCredit from './DeveloperCredit';

function LayoutContent() {
  const location = useLocation();
  const { close, isMobile } = useSidebar();
  const [syncVersion, setSyncVersion] = useState(0);

  useEffect(() => {
    if (isMobile) close();
  }, [location.pathname, isMobile, close]);

  /* Re-mount route content when Prisma data syncs (web ↔ mobile alignment) */
  useEffect(() => subscribeDataStore(() => setSyncVersion((v) => v + 1)), []);

  return (
    <div className="flex min-h-screen min-h-[100dvh] bg-gradient-to-br from-brand-50 via-white to-diamond-50">
      <Sidebar />
      <div className="flex min-w-0 flex-1 flex-col lg:min-h-screen">
        <Header />
        <main className="safe-x flex-1 px-4 py-4 sm:px-6 sm:py-6 lg:px-8 lg:py-8">
          <div className="page-container mx-auto w-full max-w-7xl">
            <Outlet key={syncVersion} />
          </div>
        </main>
        <DeveloperCredit variant="footer-light" />
      </div>
    </div>
  );
}

export default function Layout() {
  return (
    <SidebarProvider>
      <LayoutContent />
    </SidebarProvider>
  );
}
