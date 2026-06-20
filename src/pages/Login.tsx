import { useState, useEffect } from 'react';
import { Link, useNavigate, useSearchParams, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import PublicShell from '../components/PublicShell';
import { ROLE_LABELS, ROLE_DASHBOARD_PATHS, ROLE_COLORS, ROLE_QUICK_ACCESS, REGISTRATION_ROLES } from '../config/roles';
import { STATUS_BADGES } from '../config/theme';
import { ROLE_DESCRIPTIONS } from '../config/publicContent';
import type { UserRole } from '../types';

type AuthTab = 'login' | 'register';

export default function Login() {
  const [searchParams] = useSearchParams();
  const location = useLocation();
  const initialTab: AuthTab =
    location.pathname === '/register' || searchParams.get('tab') === 'register' ? 'register' : 'login';
  const [tab, setTab] = useState<AuthTab>(initialTab);

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [name, setName] = useState('');
  const [role, setRole] = useState<UserRole>('content-creator');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const { login, register, getDashboardPath, getRoleAccounts } = useAuth();
  const navigate = useNavigate();
  const roleAccounts = getRoleAccounts();

  useEffect(() => {
    const next: AuthTab =
      location.pathname === '/register' || searchParams.get('tab') === 'register' ? 'register' : 'login';
    setTab(next);
  }, [searchParams, location.pathname]);

  const clearMessages = () => {
    setError('');
    setSuccess('');
  };

  const switchTab = (next: AuthTab) => {
    clearMessages();
    setTab(next);
    navigate(next === 'register' ? '/register' : '/login', { replace: true });
  };

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    clearMessages();
    const result = await login(email, password);
    if (result.success && result.user) {
      navigate(getDashboardPath(result.user.role));
    } else {
      setError(result.error ?? 'Login failed');
    }
  };

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    clearMessages();
    if (password !== confirmPassword) {
      setError('Passwords do not match');
      return;
    }
    const result = await register(name, email, password, role);
    if (result.success) {
      setSuccess('Account created! Redirecting to your dashboard...');
      setTimeout(() => navigate(getDashboardPath(role)), 800);
    } else {
      setError(result.error ?? 'Registration failed');
    }
  };

  const quickAccessLogin = async (account: (typeof roleAccounts)[0]) => {
    setEmail(account.email);
    setPassword(account.password);
    clearMessages();
    const result = await login(account.email, account.password);
    if (result.success && result.user) {
      navigate(ROLE_DASHBOARD_PATHS[result.user.role]);
    } else {
      setError(result.error ?? 'Quick access login failed');
    }
  };

  return (
    <PublicShell active={tab === 'register' ? 'register' : 'login'}>
      <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 sm:py-12 lg:px-8">
        <div className="mb-8 text-center sm:mb-10">
          <h1 className="text-2xl font-bold tracking-tight text-white sm:text-3xl">
            {tab === 'login' ? 'Welcome Back' : 'Create Your Account'}
          </h1>
          <p className="mt-2 text-sm text-brand-100 sm:text-base">
            {tab === 'login'
              ? 'Sign in to access your role dashboard and sidebar navigation'
              : 'Register with a role to join the campaign management workflow'}
          </p>
        </div>

        <div className="grid gap-6 lg:grid-cols-5 lg:items-start lg:gap-8">
          <div className="card-glass animate-slide-up order-1 lg:col-span-2">
            <div className="auth-tabs mb-6">
              <button
                type="button"
                onClick={() => switchTab('login')}
                className={tab === 'login' ? 'auth-tab auth-tab-active' : 'auth-tab'}
              >
                Sign In
              </button>
              <button
                type="button"
                onClick={() => switchTab('register')}
                className={tab === 'register' ? 'auth-tab auth-tab-active' : 'auth-tab'}
              >
                Register
              </button>
            </div>

            {error && <div className="alert-error mb-4">{error}</div>}
            {success && <div className="alert-success mb-4">{success}</div>}

            {tab === 'login' ? (
              <form onSubmit={handleLogin} className="space-y-4">
                <div>
                  <label className="label">Email</label>
                  <input type="email" className="input-field" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="you@company.com" required />
                </div>
                <div>
                  <label className="label">Password</label>
                  <input type="password" className="input-field" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="••••••••" required />
                </div>
                <button type="submit" className="btn-primary w-full">Sign In</button>
              </form>
            ) : (
              <form onSubmit={handleRegister} className="space-y-4">
                <div>
                  <label className="label">Full Name</label>
                  <input className="input-field" value={name} onChange={(e) => setName(e.target.value)} placeholder="John Smith" required />
                </div>
                <div>
                  <label className="label">Email</label>
                  <input type="email" className="input-field" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="you@company.com" required />
                </div>
                <div>
                  <label className="label">Role</label>
                  <select className="input-field" value={role} onChange={(e) => setRole(e.target.value as UserRole)}>
                    {REGISTRATION_ROLES.map((r) => (
                      <option key={r} value={r}>{ROLE_LABELS[r]}</option>
                    ))}
                  </select>
                  <p className="mt-1.5 text-xs leading-relaxed text-slate-500">{ROLE_DESCRIPTIONS[role]}</p>
                </div>
                <div>
                  <label className="label">Password</label>
                  <input type="password" className="input-field" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Min. 6 characters" minLength={6} required />
                </div>
                <div>
                  <label className="label">Confirm Password</label>
                  <input type="password" className="input-field" value={confirmPassword} onChange={(e) => setConfirmPassword(e.target.value)} placeholder="Repeat password" required />
                </div>
                <button type="submit" className="btn-primary w-full">Create Account</button>
              </form>
            )}

            <p className="mt-5 text-center text-sm text-slate-500">
              {tab === 'login' ? (
                <>Don&apos;t have an account?{' '}
                  <button type="button" onClick={() => switchTab('register')} className="btn-link px-1">Register</button>
                </>
              ) : (
                <>Already have an account?{' '}
                  <button type="button" onClick={() => switchTab('login')} className="btn-link px-1">Sign in</button>
                </>
              )}
            </p>
          </div>

          <div className="animate-slide-up order-2 lg:col-span-3" style={{ animationDelay: '100ms' }}>
            <div className="card-glass h-full">
              <h2 className="section-title">Quick Access — All Roles</h2>
              <p className="mt-1 text-sm text-slate-500">One-click login with demo accounts. Each opens the role dashboard with full sidebar navigation.</p>

              <div className="mt-5 grid grid-cols-1 gap-4 xs:grid-cols-2">
                {roleAccounts.map((account) => (
                  <div
                    key={account.role}
                    className={`rounded-2xl border-2 p-4 transition-all duration-300 hover:-translate-y-0.5 hover:shadow-card-hover sm:p-5 ${ROLE_QUICK_ACCESS[account.role].card}`}
                  >
                    <div className="flex flex-wrap items-center justify-between gap-2">
                      <span className={`badge ${ROLE_COLORS[account.role]}`}>{ROLE_LABELS[account.role]}</span>
                      <span className={`badge ${account.status === 'active' ? STATUS_BADGES.active : STATUS_BADGES.inactive}`}>{account.status}</span>
                    </div>
                    <h3 className="mt-3 truncate text-base font-bold text-slate-900">{account.name}</h3>
                    <p className="mt-1 truncate text-sm text-slate-500">{account.email}</p>
                    <p className="mt-2 line-clamp-2 text-xs leading-relaxed text-slate-500">{ROLE_DESCRIPTIONS[account.role]}</p>
                    <button
                      type="button"
                      onClick={() => quickAccessLogin(account)}
                      className={`mt-4 ${ROLE_QUICK_ACCESS[account.role].button}`}
                    >
                      Go to Dashboard
                    </button>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>

        <p className="mt-8 text-center">
          <Link to="/" className="text-sm font-semibold text-brand-100 transition hover:text-white hover:underline">
            ← Back to Home
          </Link>
        </p>
      </div>
    </PublicShell>
  );
}
