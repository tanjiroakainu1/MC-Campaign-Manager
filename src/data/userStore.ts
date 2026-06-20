import type { User, UserRole } from '../types';
import { isRegistrationRole } from '../config/roles';
import { apiFetch } from '../lib/api';
import { getCachedUsers, reloadCache } from './dataStore';

export interface RoleAccount {
  role: UserRole;
  name: string;
  email: string;
  password: string;
  userId: string;
  status: User['status'];
}

let demoAccountsCache: RoleAccount[] | null = null;

export function getAllUsers(): User[] {
  return getCachedUsers();
}

export function getUsersByRole(role: UserRole): User[] {
  return getAllUsers().filter((u) => u.role === role);
}

export function getUserById(id: string): User | undefined {
  return getAllUsers().find((u) => u.id === id);
}

export async function loadDemoAccounts(): Promise<void> {
  try {
    const { accounts } = await apiFetch<{ accounts: RoleAccount[] }>('/auth/demo-accounts');
    demoAccountsCache = accounts;
  } catch {
    demoAccountsCache = [];
  }
}

export function getRoleAccounts(): RoleAccount[] {
  return demoAccountsCache ?? [];
}

export async function validateLogin(
  email: string,
  password: string
): Promise<{ user: User | null; error?: string }> {
  try {
    const { user } = await apiFetch<{ user: User }>('/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    });
    return { user };
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Login failed';
    return { user: null, error: message };
  }
}

export async function registerUser(
  name: string,
  email: string,
  password: string,
  role: UserRole
): Promise<{ success: boolean; error?: string; user?: User }> {
  if (!isRegistrationRole(role)) {
    return { success: false, error: 'Super Admin accounts cannot be created via registration.' };
  }
  try {
    const { user } = await apiFetch<{ user: User }>('/auth/register', {
      method: 'POST',
      body: JSON.stringify({ name, email, password, role }),
    });
    await reloadCache();
    await loadDemoAccounts();
    return { success: true, user };
  } catch (err) {
    return { success: false, error: err instanceof Error ? err.message : 'Registration failed' };
  }
}

export async function addUser(
  user: Omit<User, 'id' | 'createdAt'>,
  password: string
): Promise<User> {
  const created = await apiFetch<User>('/users', {
    method: 'POST',
    body: JSON.stringify({ user, password, actor: user.name }),
  });
  await reloadCache();
  await loadDemoAccounts();
  return created;
}

export async function updateUser(id: string, data: Partial<User>): Promise<User | null> {
  try {
    const updated = await apiFetch<User>(`/users/${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ data, actor: 'System' }),
    });
    await reloadCache();
    await loadDemoAccounts();
    return updated;
  } catch {
    return null;
  }
}

export async function deleteUser(id: string): Promise<boolean> {
  try {
    await apiFetch(`/users/${id}`, {
      method: 'DELETE',
      body: JSON.stringify({ actor: 'System' }),
    });
    await reloadCache();
    await loadDemoAccounts();
    return true;
  } catch {
    return false;
  }
}

export function setUserPassword(_email: string, _password: string): void {
  /* passwords managed server-side */
}

export function getPasswordForEmail(_email: string): string | undefined {
  return undefined;
}
