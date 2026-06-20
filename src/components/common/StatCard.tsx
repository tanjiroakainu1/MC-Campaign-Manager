interface StatCardProps {
  title: string;
  value: string | number;
  change?: number;
  icon?: React.ReactNode;
  color?: string;
}

export default function StatCard({ title, value, change, icon, color = 'bg-gradient-to-br from-brand-100 to-diamond-200 text-brand-700' }: StatCardProps) {
  return (
    <div className="card-hover group min-h-[7.5rem]">
      <div className="flex h-full items-start justify-between gap-3">
        <div className="min-w-0 flex-1">
          <p className="truncate text-[10px] font-bold uppercase tracking-wide text-slate-500 xs:text-xs sm:text-sm sm:normal-case sm:tracking-normal">
            {title}
          </p>
          <p className="mt-2 truncate text-xl font-bold tracking-tight text-slate-900 xs:text-2xl sm:text-3xl">{value}</p>
          {change !== undefined && (
            <p className={`mt-1.5 flex items-center gap-1 text-xs font-bold sm:text-sm ${change >= 0 ? 'text-brand-600' : 'text-red-600'}`}>
              <span>{change >= 0 ? '↑' : '↓'}</span>
              {Math.abs(change)}% from last period
            </p>
          )}
        </div>
        {icon && (
          <div className={`shrink-0 rounded-xl p-2.5 shadow-sm transition-all duration-300 group-hover:scale-110 group-hover:shadow-glow-sm sm:p-3 ${color}`}>
            {icon}
          </div>
        )}
      </div>
    </div>
  );
}
