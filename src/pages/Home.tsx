import { Link } from 'react-router-dom';
import PublicShell from '../components/PublicShell';
import DeveloperCredit from '../components/DeveloperCredit';
import { getRoleAccounts } from '../data/userStore';
import { ROLE_LABELS, ROLE_COLORS, ROLE_QUICK_ACCESS } from '../config/roles';
import {
  ROLE_DESCRIPTIONS,
  GET_STARTED_STEPS,
  CAMPAIGN_LIFECYCLE,
  PLATFORM_FEATURES,
  MOBILE_APP_HIGHLIGHTS,
  getRoleFeatures,
} from '../config/publicContent';
import { MOBILE_APP } from '../config/mobileApp';
import type { UserRole } from '../types';

const ROLE_ICONS: Record<UserRole, React.ReactNode> = {
  'super-admin': (
    <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
    </svg>
  ),
  'marketing-manager': (
    <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z" />
    </svg>
  ),
  'content-creator': (
    <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
    </svg>
  ),
  'marketing-analyst': (
    <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
    </svg>
  ),
};

const FEATURE_ICONS: Record<string, React.ReactNode> = {
  shield: (
    <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
    </svg>
  ),
  flow: (
    <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
    </svg>
  ),
  database: (
    <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" />
    </svg>
  ),
  responsive: (
    <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z" />
    </svg>
  ),
};

const roles = getRoleAccounts().map((account) => ({
  role: account.role,
  name: account.name,
  email: account.email,
}));

export default function Home() {
  return (
    <PublicShell active="home">
      {/* Hero */}
      <section className="section-padding pb-8 pt-10 sm:pb-12 sm:pt-14 lg:pb-16 lg:pt-16">
        <div className="mx-auto max-w-7xl">
          <div className="mx-auto max-w-4xl text-center">
            <div className="animate-slide-up">
              <span className="inline-flex items-center gap-2 rounded-full border border-white/20 bg-white/10 px-4 py-1.5 text-xs font-bold uppercase tracking-widest text-brand-100 backdrop-blur-sm">
                <span className="h-1.5 w-1.5 rounded-full bg-diamond-400 shadow-glow-sm" />
                Blue Diamond Theme
              </span>
              <h1 className="text-balance mt-6 text-4xl font-bold tracking-tight text-white sm:text-5xl lg:text-6xl">
                Plan, Create &amp; Measure Campaigns —{' '}
                <span className="bg-gradient-to-r from-brand-200 to-white bg-clip-text text-transparent">
                  Together
                </span>
              </h1>
              <p className="mx-auto mt-5 max-w-2xl text-base leading-relaxed text-brand-100 sm:text-lg">
                A role-based platform where Super Admins, Marketing Managers, Content Creators, and
                Analysts collaborate on campaigns from planning through performance tracking.
              </p>
            </div>

            <div className="animate-slide-up mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row sm:gap-4" style={{ animationDelay: '80ms' }}>
              <Link to="/register" className="btn-primary w-full min-w-[180px] sm:w-auto">
                Create Free Account
              </Link>
              <Link to="/login" className="btn-glass w-full min-w-[180px] sm:w-auto">
                Sign In to Dashboard
              </Link>
              <a
                href={MOBILE_APP.apkUrl}
                download={MOBILE_APP.fileName}
                className="inline-flex w-full min-w-[180px] items-center justify-center gap-2 rounded-xl border-2 border-diamond-400/60 bg-diamond-500/20 px-5 py-3 text-sm font-bold text-white backdrop-blur-sm transition hover:bg-diamond-500/30 sm:w-auto"
              >
                <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 18h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                </svg>
                Download Android APK
              </a>
            </div>

            <div className="animate-slide-up mt-10 grid grid-cols-2 gap-3 sm:grid-cols-4 sm:gap-4" style={{ animationDelay: '160ms' }}>
              {[
                { value: '4', label: 'Specialized Roles' },
                { value: '28+', label: 'Feature Pages' },
                { value: '1', label: 'Unified Workflow' },
                { value: '∞', label: 'Campaigns Tracked' },
              ].map((stat) => (
                <div
                  key={stat.label}
                  className="rounded-2xl border border-white/15 bg-white/10 px-3 py-4 backdrop-blur-sm sm:px-4"
                >
                  <p className="text-2xl font-bold text-white sm:text-3xl">{stat.value}</p>
                  <p className="mt-1 text-xs font-semibold text-brand-200 sm:text-sm">{stat.label}</p>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Platform Features */}
      <section className="section-padding border-y border-white/10 bg-white/5 backdrop-blur-sm py-12 sm:py-14">
        <div className="mx-auto max-w-7xl">
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 lg:gap-5">
            {PLATFORM_FEATURES.map((feature, i) => (
              <div
                key={feature.title}
                className="animate-slide-up rounded-2xl border border-white/15 bg-white/95 p-5 shadow-soft transition hover:-translate-y-0.5 hover:shadow-card-hover sm:p-6"
                style={{ animationDelay: `${i * 60}ms` }}
              >
                <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-brand-100 text-brand-600">
                  {FEATURE_ICONS[feature.icon]}
                </div>
                <h3 className="mt-4 text-base font-bold text-slate-900">{feature.title}</h3>
                <p className="mt-2 text-sm leading-relaxed text-slate-600">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* How It Works */}
      <section id="how-it-works" className="section-padding scroll-mt-20">
        <div className="mx-auto max-w-7xl">
          <div className="text-center">
            <p className="text-xs font-bold uppercase tracking-widest text-brand-200">Getting Started</p>
            <h2 className="text-balance mt-2 text-3xl font-bold text-white sm:text-4xl">How the System Works</h2>
            <p className="mx-auto mt-3 max-w-2xl text-sm leading-relaxed text-brand-100 sm:text-base">
              From your first sign-in to running full campaigns — here&apos;s the journey every user follows.
            </p>
          </div>

          <div className="mt-12 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4 lg:gap-6">
            {GET_STARTED_STEPS.map((item, i) => (
              <div
                key={item.step}
                className="animate-slide-up relative rounded-2xl border border-white/15 bg-white/95 p-6 shadow-soft"
                style={{ animationDelay: `${i * 80}ms` }}
              >
                <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-brand-600 text-lg font-bold text-white shadow-sm">
                  {item.step}
                </div>
                <h3 className="mt-4 text-lg font-bold text-slate-900">{item.title}</h3>
                <p className="mt-2 text-sm leading-relaxed text-slate-600">{item.description}</p>
                {i < GET_STARTED_STEPS.length - 1 && (
                  <div className="absolute -right-3 top-1/2 hidden h-6 w-6 -translate-y-1/2 items-center justify-center rounded-full bg-brand-600 text-white lg:flex">
                    <svg className="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M9 5l7 7-7 7" />
                    </svg>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Campaign Flow */}
      <section id="flow" className="section-padding scroll-mt-20 border-t border-white/10">
        <div className="mx-auto max-w-7xl">
          <div className="text-center">
            <p className="text-xs font-bold uppercase tracking-widest text-brand-200">Collaboration</p>
            <h2 className="text-balance mt-2 text-2xl font-bold text-white xs:text-3xl sm:text-4xl">Campaign Lifecycle Flow</h2>
            <p className="mx-auto mt-3 max-w-2xl text-sm leading-relaxed text-brand-100 sm:text-base">
              Campaigns move through four phases — each role owns a stage and hands off to the next.
            </p>
            <p className="mt-2 text-xs font-semibold text-diamond-300 md:hidden">Swipe to explore →</p>
          </div>

          <div className="flow-scroll mt-8 sm:mt-12">
            {CAMPAIGN_LIFECYCLE.map((stage, i) => (
              <div key={stage.phase} className="relative h-full">
                <div
                  className={`animate-slide-up h-full rounded-2xl border-2 p-5 shadow-soft sm:p-6 ${ROLE_QUICK_ACCESS[stage.role].card}`}
                  style={{ animationDelay: `${i * 100}ms` }}
                >
                    <div className="flex items-center justify-between gap-2">
                      <span className={`badge ${ROLE_COLORS[stage.role]}`}>{ROLE_LABELS[stage.role]}</span>
                      <span className="rounded-full bg-slate-900/5 px-2.5 py-0.5 text-xs font-bold uppercase tracking-wider text-slate-500">
                        {stage.phase}
                      </span>
                    </div>
                    <div className={`mt-4 flex h-10 w-10 items-center justify-center rounded-xl ${ROLE_QUICK_ACCESS[stage.role].icon}`}>
                      {ROLE_ICONS[stage.role]}
                    </div>
                    <h3 className="mt-4 text-lg font-bold text-slate-900">{stage.title}</h3>
                    <p className="mt-2 text-sm leading-relaxed text-slate-600">{stage.description}</p>
                  </div>
                  {i < CAMPAIGN_LIFECYCLE.length - 1 && (
                    <div className="absolute -right-2.5 top-1/2 z-10 hidden h-5 w-5 -translate-y-1/2 items-center justify-center rounded-full bg-white text-brand-600 shadow-md lg:flex">
                      <svg className="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M9 5l7 7-7 7" />
                      </svg>
                    </div>
                  )}
              </div>
            ))}
          </div>

          <div className="mt-8 rounded-2xl border border-white/15 bg-white/10 p-4 backdrop-blur-sm sm:mt-10 sm:p-6">
            <p className="text-center text-sm leading-relaxed text-brand-100 sm:text-base">
              <span className="font-bold text-white">Data flows seamlessly</span> — when a manager creates a campaign,
              creators see assigned work, and analysts pull live metrics from the same shared store.
            </p>
          </div>
        </div>
      </section>

      {/* Roles */}
      <section id="roles" className="section-padding scroll-mt-20 border-t border-white/10 bg-white/5 backdrop-blur-sm">
        <div className="mx-auto max-w-7xl">
          <div className="text-center">
            <p className="text-xs font-bold uppercase tracking-widest text-brand-200">Team Roles</p>
            <h2 className="text-balance mt-2 text-3xl font-bold text-white sm:text-4xl">Explore Each Role</h2>
            <p className="mx-auto mt-3 max-w-2xl text-sm leading-relaxed text-brand-100 sm:text-base">
              Every role has a dedicated dashboard, sidebar navigation, and feature pages. Try a demo account instantly.
            </p>
          </div>

          <div className="mt-12 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:gap-6">
            {roles.map(({ role, name, email }, i) => (
              <div
                key={role}
                className={`animate-slide-up rounded-2xl border-2 p-5 transition-all duration-300 hover:-translate-y-1 hover:shadow-card-hover sm:p-6 ${ROLE_QUICK_ACCESS[role].card}`}
                style={{ animationDelay: `${i * 80}ms` }}
              >
                <div className="flex items-start justify-between gap-3">
                  <div className={`flex h-12 w-12 shrink-0 items-center justify-center rounded-xl ${ROLE_QUICK_ACCESS[role].icon}`}>
                    {ROLE_ICONS[role]}
                  </div>
                  <span className={`badge shrink-0 ${ROLE_COLORS[role]}`}>{ROLE_LABELS[role]}</span>
                </div>

                <h3 className="mt-4 text-lg font-bold text-slate-900">{ROLE_LABELS[role]}</h3>
                <p className="mt-2 text-sm leading-relaxed text-slate-600">{ROLE_DESCRIPTIONS[role]}</p>

                <ul className="mt-4 space-y-1.5">
                  {getRoleFeatures(role).map((feature) => (
                    <li key={feature} className="flex items-center gap-2 text-sm text-slate-600">
                      <svg className="h-4 w-4 shrink-0 text-diamond-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M5 13l4 4L19 7" />
                      </svg>
                      {feature}
                    </li>
                  ))}
                </ul>

                <div className="mt-5 rounded-xl border border-slate-200/80 bg-white/80 px-4 py-3">
                  <p className="text-xs font-bold uppercase tracking-wider text-slate-400">Demo Account</p>
                  <p className="mt-1 text-sm font-semibold text-slate-800">{name}</p>
                  <p className="truncate text-xs text-slate-500">{email}</p>
                </div>

                <Link to="/login" className={`mt-4 ${ROLE_QUICK_ACCESS[role].button}`}>
                  Try {ROLE_LABELS[role]} Dashboard
                </Link>
              </div>
            ))}
          </div>
        </div>
      </section>

      <DeveloperCredit variant="hero" />

      {/* Android APK */}
      <section id="android-app" className="section-padding scroll-mt-20 border-t border-white/10">
        <div className="mx-auto max-w-7xl">
          <div className="grid grid-cols-1 items-center gap-8 lg:grid-cols-2 lg:gap-12">
            <div>
              <p className="text-xs font-bold uppercase tracking-widest text-brand-200">Mobile App</p>
              <h2 className="text-balance mt-2 text-3xl font-bold text-white sm:text-4xl">
                Test on Android
              </h2>
              <p className="mt-4 text-sm leading-relaxed text-brand-100 sm:text-base">
                Download the release APK and install it on your phone or Android emulator. The app syncs
                with the same Prisma database as this website — create a campaign on web and see it on
                mobile within seconds.
              </p>
              <ul className="mt-6 space-y-3">
                {MOBILE_APP_HIGHLIGHTS.map((item) => (
                  <li key={item} className="flex items-start gap-3 text-sm text-brand-100">
                    <svg className="mt-0.5 h-5 w-5 shrink-0 text-diamond-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M5 13l4 4L19 7" />
                    </svg>
                    {item}
                  </li>
                ))}
              </ul>
            </div>

            <div className="animate-scale-in rounded-3xl border border-white/20 bg-white/95 p-6 shadow-glow sm:p-8">
              <div className="flex items-center gap-4">
                <div className="flex h-16 w-16 items-center justify-center rounded-2xl bg-gradient-to-br from-brand-500 to-diamond-500 text-white shadow-md">
                  <svg className="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 18h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                  </svg>
                </div>
                <div>
                  <h3 className="text-xl font-bold text-slate-900">{MOBILE_APP.label}</h3>
                  <p className="text-sm text-slate-500">v{MOBILE_APP.version} · {MOBILE_APP.sizeHint}</p>
                </div>
              </div>

              <div className="mt-6 space-y-3 rounded-xl border border-slate-200 bg-slate-50 p-4 text-sm">
                <div className="flex justify-between gap-4">
                  <span className="font-semibold text-slate-500">Package</span>
                  <span className="truncate text-right font-mono text-xs text-slate-700">{MOBILE_APP.packageId}</span>
                </div>
                <div className="flex justify-between gap-4">
                  <span className="font-semibold text-slate-500">API</span>
                  <span className="truncate text-right font-mono text-xs text-slate-700">{MOBILE_APP.apiUrl}</span>
                </div>
              </div>

              <a
                href={MOBILE_APP.apkUrl}
                download={MOBILE_APP.fileName}
                className="btn-primary mt-6 flex w-full items-center justify-center gap-2"
              >
                <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                </svg>
                Download APK for Android
              </a>

              <p className="mt-4 text-center text-xs leading-relaxed text-slate-500">
                On emulator: open this site in Chrome, tap download, then allow installs from unknown sources if prompted.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="section-padding pb-20 pt-8 sm:pb-24">
        <div className="mx-auto max-w-3xl">
          <div className="animate-scale-in rounded-3xl border border-white/20 bg-white/95 p-8 text-center shadow-glow sm:p-10">
            <h2 className="text-2xl font-bold text-slate-900 sm:text-3xl">Ready to get started?</h2>
            <p className="mx-auto mt-3 max-w-lg text-sm leading-relaxed text-slate-600 sm:text-base">
              Register for your role, or sign in with a demo account on the login page for instant one-click access to any dashboard.
            </p>
            <div className="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row sm:gap-4">
              <Link to="/register" className="btn-primary w-full sm:w-auto">
                Register Now
              </Link>
              <Link to="/login" className="btn-secondary w-full sm:w-auto">
                Sign In
              </Link>
            </div>
          </div>
        </div>
      </section>
    </PublicShell>
  );
}
