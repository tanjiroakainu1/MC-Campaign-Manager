import { Link } from 'react-router-dom';

interface QuickActionCardProps {
  to: string;
  label: string;
  accent?: string;
}

export default function QuickActionCard({ to, label, accent = 'bg-gradient-to-br from-brand-100 to-diamond-200 text-brand-700' }: QuickActionCardProps) {
  return (
    <Link to={to} className="card-hover group flex min-h-[56px] items-center gap-3 sm:min-h-0 sm:gap-4">
      <div className={`flex h-11 w-11 shrink-0 items-center justify-center rounded-xl shadow-sm transition-all duration-300 group-hover:scale-110 group-hover:shadow-glow-sm sm:h-12 sm:w-12 ${accent}`}>
        <svg className="h-5 w-5 transition-transform duration-300 group-hover:translate-x-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7l5 5m0 0l-5 5m5-5H6" />
        </svg>
      </div>
      <span className="text-sm font-bold text-slate-700 transition-colors group-hover:text-brand-700 sm:text-base">{label}</span>
    </Link>
  );
}
