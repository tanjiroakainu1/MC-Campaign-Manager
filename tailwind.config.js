/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'sans-serif'],
      },
      colors: {
        brand: {
          50: '#eef7ff',
          100: '#d9ecff',
          200: '#b8dcff',
          300: '#85c4ff',
          400: '#52a8ff',
          500: '#2b8fff',
          600: '#1470eb',
          700: '#0d58c7',
          800: '#1048a3',
          900: '#133d85',
          950: '#0c2657',
        },
        diamond: {
          50: '#f0fbff',
          100: '#e0f6ff',
          200: '#b8ecff',
          300: '#7ddcff',
          400: '#38c8ff',
          500: '#0cb0f5',
          600: '#0090d4',
          700: '#0073ab',
          800: '#06618d',
          900: '#0b5174',
          950: '#07344d',
        },
      },
      boxShadow: {
        soft: '0 2px 15px -3px rgba(12, 38, 87, 0.08), 0 10px 20px -2px rgba(12, 38, 87, 0.05)',
        glow: '0 0 40px -10px rgba(43, 143, 255, 0.45)',
        'glow-sm': '0 4px 20px -4px rgba(56, 200, 255, 0.4)',
        'glow-diamond': '0 0 60px -12px rgba(125, 220, 255, 0.55), 0 0 20px -4px rgba(43, 143, 255, 0.3)',
        card: '0 1px 3px 0 rgba(12, 38, 87, 0.06), 0 1px 2px -1px rgba(12, 38, 87, 0.04)',
        'card-hover': '0 12px 40px -12px rgba(12, 38, 87, 0.18), 0 4px 16px -4px rgba(43, 143, 255, 0.12)',
        button: '0 4px 14px -2px rgba(20, 112, 235, 0.4)',
        crystal: 'inset 0 1px 0 0 rgba(255, 255, 255, 0.25), 0 4px 20px -4px rgba(43, 143, 255, 0.35)',
      },
      backgroundImage: {
        'diamond-mesh': 'radial-gradient(circle at 20% 20%, rgba(125, 220, 255, 0.15) 0%, transparent 50%), radial-gradient(circle at 80% 80%, rgba(43, 143, 255, 0.12) 0%, transparent 50%)',
        'diamond-gradient': 'linear-gradient(135deg, #0c2657 0%, #1048a3 35%, #2b8fff 70%, #7ddcff 100%)',
        'diamond-surface': 'linear-gradient(180deg, #ffffff 0%, #eef7ff 100%)',
      },
      animation: {
        'fade-in': 'fadeIn 0.4s ease-out',
        'slide-up': 'slideUp 0.4s ease-out',
        'slide-down': 'slideDown 0.3s ease-out',
        'slide-in-left': 'slideInLeft 0.3s ease-out',
        'scale-in': 'scaleIn 0.25s ease-out',
        shimmer: 'shimmer 2s linear infinite',
        'diamond-pulse': 'diamondPulse 3s ease-in-out infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { opacity: '0', transform: 'translateY(12px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        slideDown: {
          '0%': { opacity: '0', transform: 'translateY(-8px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        slideInLeft: {
          '0%': { opacity: '0', transform: 'translateX(-16px)' },
          '100%': { opacity: '1', transform: 'translateX(0)' },
        },
        scaleIn: {
          '0%': { opacity: '0', transform: 'scale(0.96)' },
          '100%': { opacity: '1', transform: 'scale(1)' },
        },
        shimmer: {
          '0%': { backgroundPosition: '-200% 0' },
          '100%': { backgroundPosition: '200% 0' },
        },
        diamondPulse: {
          '0%, 100%': { opacity: '0.6' },
          '50%': { opacity: '1' },
        },
        chartBarGrowV: {
          '0%': { transform: 'scaleY(0)' },
          '100%': { transform: 'scaleY(1)' },
        },
        chartBarGrowH: {
          '0%': { transform: 'scaleX(0)' },
          '100%': { transform: 'scaleX(1)' },
        },
        chartDonutReveal: {
          '0%': { strokeDasharray: '0 1000', opacity: '0' },
          '100%': { strokeDasharray: 'var(--dash) 1000', opacity: '1' },
        },
        chartAreaFade: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        chartLineDraw: {
          '0%': { strokeDashoffset: '1000' },
          '100%': { strokeDashoffset: '0' },
        },
        chartDotPop: {
          '0%': { opacity: '0', transform: 'scale(0)' },
          '100%': { opacity: '1', transform: 'scale(1)' },
        },
        chartGaugeFill: {
          '0%': { strokeDasharray: '0 1000' },
          '100%': { strokeDasharray: 'var(--gauge-dash) 1000' },
        },
        chartGaugePop: {
          '0%': { opacity: '0', transform: 'scale(0.8)' },
          '100%': { opacity: '1', transform: 'scale(1)' },
        },
      },
      screens: {
        xs: '475px',
      },
    },
  },
  plugins: [],
};
