interface GaugeChartProps {
  value: number;
  label: string;
  suffix?: string;
  size?: number;
}

export default function GaugeChart({ value, label, suffix = '%', size = 200 }: GaugeChartProps) {
  const clamped = Math.min(Math.max(value, 0), 100);
  const stroke = 18;
  const radius = (size - stroke * 2) / 2;
  const circumference = Math.PI * radius;
  const dash = (clamped / 100) * circumference;

  const color = clamped >= 75 ? '#1470eb' : clamped >= 45 ? '#2b8fff' : '#38c8ff';

  return (
    <div className="chart-gauge-wrap">
      <svg width={size} height={size / 2 + 24} viewBox={`0 0 ${size} ${size / 2 + 24}`} className="chart-gauge-svg">
        <defs>
          <linearGradient id="gauge-gradient" x1="0" y1="0" x2="1" y2="0">
            <stop offset="0%" stopColor="#7ddcff" />
            <stop offset="50%" stopColor="#2b8fff" />
            <stop offset="100%" stopColor="#1470eb" />
          </linearGradient>
          <filter id="gauge-glow">
            <feGaussianBlur stdDeviation="2" result="blur" />
            <feMerge>
              <feMergeNode in="blur" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>
        </defs>
        <path
          d={`M ${stroke} ${size / 2} A ${radius} ${radius} 0 0 1 ${size - stroke} ${size / 2}`}
          fill="none"
          stroke="#e0f6ff"
          strokeWidth={stroke}
          strokeLinecap="round"
        />
        <path
          d={`M ${stroke} ${size / 2} A ${radius} ${radius} 0 0 1 ${size - stroke} ${size / 2}`}
          fill="none"
          stroke="url(#gauge-gradient)"
          strokeWidth={stroke}
          strokeLinecap="round"
          strokeDasharray={`${dash} ${circumference}`}
          className="chart-gauge-fill"
          filter="url(#gauge-glow)"
        />
      </svg>
      <div className="chart-gauge-center">
        <p className="chart-gauge-value" style={{ color }}>{clamped}{suffix}</p>
        <p className="text-xs font-bold uppercase tracking-wider text-slate-500">{label}</p>
      </div>
    </div>
  );
}
