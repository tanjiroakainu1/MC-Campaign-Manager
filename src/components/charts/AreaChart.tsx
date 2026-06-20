import type { ChartPoint } from '../../utils/chartData';

interface AreaChartProps {
  data: ChartPoint[];
  height?: number;
  formatValue?: (v: number) => string;
}

export default function AreaChart({ data, height = 160, formatValue = (v) => String(v) }: AreaChartProps) {
  if (data.length === 0) {
    return <p className="py-8 text-center text-sm text-slate-500">No data to chart</p>;
  }

  const width = 400;
  const pad = { top: 16, right: 12, bottom: 28, left: 12 };
  const innerW = width - pad.left - pad.right;
  const innerH = height - pad.top - pad.bottom;
  const max = Math.max(...data.map((d) => d.value), 1);
  const min = 0;

  const points = data.map((d, i) => {
    const x = pad.left + (i / Math.max(data.length - 1, 1)) * innerW;
    const y = pad.top + innerH - ((d.value - min) / (max - min)) * innerH;
    return { x, y, ...d };
  });

  const linePath = points.map((p, i) => `${i === 0 ? 'M' : 'L'} ${p.x} ${p.y}`).join(' ');
  const areaPath = `${linePath} L ${points[points.length - 1].x} ${pad.top + innerH} L ${points[0].x} ${pad.top + innerH} Z`;

  return (
    <div className="chart-area-wrap">
      <svg viewBox={`0 0 ${width} ${height}`} className="chart-area-svg w-full" preserveAspectRatio="xMidYMid meet">
        <defs>
          <linearGradient id="area-gradient" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor="#2b8fff" stopOpacity="0.45" />
            <stop offset="50%" stopColor="#38c8ff" stopOpacity="0.2" />
            <stop offset="100%" stopColor="#7ddcff" stopOpacity="0" />
          </linearGradient>
          <linearGradient id="line-gradient" x1="0" y1="0" x2="1" y2="0">
            <stop offset="0%" stopColor="#1470eb" />
            <stop offset="50%" stopColor="#2b8fff" />
            <stop offset="100%" stopColor="#38c8ff" />
          </linearGradient>
        </defs>
        {[0.25, 0.5, 0.75].map((pct) => (
          <line
            key={pct}
            x1={pad.left}
            y1={pad.top + innerH * (1 - pct)}
            x2={width - pad.right}
            y2={pad.top + innerH * (1 - pct)}
            stroke="#d9ecff"
            strokeWidth="1"
            strokeDasharray="4 4"
          />
        ))}
        <path d={areaPath} fill="url(#area-gradient)" className="chart-area-fill" />
        <path d={linePath} fill="none" stroke="url(#line-gradient)" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round" className="chart-area-line" />
        {points.map((p, i) => (
          <g key={p.label}>
            <circle cx={p.x} cy={p.y} r="5" fill="#fff" stroke="#2b8fff" strokeWidth="2" className="chart-area-dot" style={{ animationDelay: `${i * 100}ms` }} />
            <text x={p.x} y={height - 6} textAnchor="middle" className="chart-area-label">{p.label}</text>
          </g>
        ))}
      </svg>
      <div className="mt-2 flex justify-between text-xs text-slate-500">
        <span>Min: {formatValue(Math.min(...data.map((d) => d.value)))}</span>
        <span>Peak: {formatValue(max)}</span>
      </div>
    </div>
  );
}
