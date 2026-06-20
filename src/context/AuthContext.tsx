import { createContext, useContext, useState, useCallback, type ReactNode } from 'react';
import type { User, UserRole } from '../types';
import { ROLE_DASHBOARD_PATHS } from '../config/roles';
import {
  validateLogin,
  registerUser as registerUserStore,
  getRoleAccounts,
  type RoleAccount,
} from '../data/userStore';

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<{ success: boolean; user?: User; error?: string }>;
  register: (name: string, email: string, password: string, role: UserRole) => Promise<{ success: boolean; error?: string }>;
  logout: () => void;
  getDashboardPath: (role?: UserRole) => string;
  getRoleAccounts: () => RoleAccount[];
}

const AuthContext = createContext<AuthContextType | null>(null);

const SESSION_KEY = 'mcm_user';

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(() => {
    try {
      const stored = localStorage.getItem(SESSION_KEY);
      return stored ? (JSON.parse(stored) as User) : null;
    } catch {
      return null;
    }
  });

  const login = useCallback(async (email: string, password: string) => {
    const { user: foundUser, error } = await validateLogin(email, password);
    if (foundUser) {
      setUser(foundUser);
      localStorage.setItem(SESSION_KEY, JSON.stringify(foundUser));
      return { success: true, user: foundUser };
    }
    return { success: false, error: error ?? 'Invalid email or password' };
  }, []);

  const register = useCallback(async (name: string, email: string, password: string, role: UserRole) => {
    const result = await registerUserStore(name, email, password, role);
    if (result.success && result.user) {
      setUser(result.user);
      localStorage.setItem(SESSION_KEY, JSON.stringify(result.user));
      return { success: true };
    }
    return { success: false, error: result.error };
  }, []);

  const logout = useCallback(() => {
    setUser(null);
    localStorage.removeItem(SESSION_KEY);
  }, []);

  const getDashboardPath = useCallback(
    (role?: UserRole) => {
      const r = role ?? user?.role;
      return r ? ROLE_DASHBOARD_PATHS[r] : '/login';
    },
    [user]
  );

  return (
    <AuthContext.Provider
      value={{
        user,
        isAuthenticated: !!user,
        login,
        register,
        logout,
        getDashboardPath,
        getRoleAccounts,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used within AuthProvider');
  return context;
}
