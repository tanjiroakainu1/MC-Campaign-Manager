interface BarChartProps {
  data: { label: string; value: number; max?: number }[];
  formatValue?: (v: number) => string;
  variant?: 'vertical' | 'horizontal';
}

export default function BarChart({ data, formatValue = (v) => String(v), variant = 'vertical' }: BarChartProps) {
  if (data.length === 0) {
    return <p className="py-8 text-center text-sm text-slate-500">No data to chart</p>;
  }

  const maxVal = Math.max(...data.map((d) => d.max ?? d.value), 1);

  if (variant === 'horizontal') {
    return (
      <div className="space-y-3">
        {data.map((item, i) => {
          const pct = Math.round((item.value / maxVal) * 100);
          return (
            <div key={item.label} className="chart-bar-row" style={{ animationDelay: `${i * 80}ms` }}>
              <div className="mb-1 flex justify-between text-xs">
                <span className="truncate font-semibold capitalize text-slate-700">{item.label}</span>
                <span className="shrink-0 font-bold text-brand-700">{formatValue(item.value)}</span>
              </div>
              <div className="chart-bar-track">
                <div className="chart-bar-fill chart-bar-fill-h" style={{ width: `${pct}%`, animationDelay: `${i * 100}ms` }} />
              </div>
            </div>
          );
        })}
      </div>
    );
  }

  return (
    <div className="chart-bar-vertical-wrap">
      <div className="chart-bar-vertical-grid">
        {data.map((item, i) => {
          const pct = Math.round((item.value / maxVal) * 100);
          return (
            <div key={item.label} className="chart-bar-col" style={{ animationDelay: `${i * 90}ms` }}>
              <div className="chart-bar-track-v">
                <div
                  className="chart-bar-fill chart-bar-fill-v"
                  style={{ height: `${Math.max(pct, 4)}%`, animationDelay: `${i * 120}ms` }}
                  title={formatValue(item.value)}
                />
              </div>
              <span className="chart-bar-value">{formatValue(item.value)}</span>
              <span className="chart-bar-label">{item.label}</span>
            </div>
          );
        })}
      </div>
    </div>
  );
}
