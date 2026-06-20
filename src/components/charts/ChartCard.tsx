interface ChartCardProps {
  title: string;
  subtitle?: string;
  children: React.ReactNode;
  className?: string;
  glow?: boolean;
}

export default function ChartCard({ title, subtitle, children, className = '', glow = false }: ChartCardProps) {
  return (
    <div className={`chart-card ${glow ? 'chart-card-glow' : ''} ${className}`}>
      <div className="mb-4">
        <h3 className="section-title">{title}</h3>
        {subtitle && <p className="mt-1 text-xs text-slate-500">{subtitle}</p>}
      </div>
      {children}
    </div>
  );
}
