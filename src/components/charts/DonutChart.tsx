import type { ChartSegment } from '../../utils/chartData';

interface DonutChartProps {
  segments: ChartSegment[];
  centerLabel?: string;
  centerValue?: string;
  size?: number;
}

export default function DonutChart({ segments, centerLabel, centerValue, size = 180 }: DonutChartProps) {
  if (segments.length === 0) {
    return <p className="py-8 text-center text-sm text-slate-500">No data to chart</p>;
  }

  const total = segments.reduce((s, seg) => s + seg.value, 0) || 1;
  const stroke = 28;
  const radius = (size - stroke) / 2;
  const circumference = 2 * Math.PI * radius;
  let offset = 0;

  return (
    <div className="chart-donut-wrap">
      <div className="relative shrink-0">
        <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`} className="chart-donut-svg">
        <defs>
          <filter id="donut-glow">
            <feGaussianBlur stdDeviation="3" result="blur" />
            <feMerge>
              <feMergeNode in="blur" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>
        </defs>
        <circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          fill="none"
          stroke="#e0f6ff"
          strokeWidth={stroke}
        />
        {segments.map((seg, i) => {
          const pct = seg.value / total;
          const dash = pct * circumference;
          const gap = circumference - dash;
          const rotation = (offset / circumference) * 360 - 90;
          offset += dash;
          return (
            <circle
              key={seg.label}
              cx={size / 2}
              cy={size / 2}
              r={radius}
              fill="none"
              stroke={seg.color}
              strokeWidth={stroke}
              strokeDasharray={`${dash} ${gap}`}
              strokeDashoffset={0}
              strokeLinecap="round"
              transform={`rotate(${rotation} ${size / 2} ${size / 2})`}
              className="chart-donut-segment"
              style={{ animationDelay: `${i * 150}ms` }}
            />
          );
        })}
        </svg>
        {(centerLabel || centerValue) && (
          <div className="chart-donut-center">
            {centerValue && <p className="text-2xl font-bold text-brand-700">{centerValue}</p>}
            {centerLabel && <p className="text-xs font-semibold uppercase tracking-wider text-slate-500">{centerLabel}</p>}
          </div>
        )}
      </div>
      <div className="chart-legend">
        {segments.map((seg) => (
          <div key={seg.label} className="chart-legend-item">
            <span className="chart-legend-dot" style={{ background: seg.color }} />
            <span className="capitalize text-slate-600">{seg.label}</span>
            <span className="ml-auto font-bold text-slate-800">{seg.value}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
