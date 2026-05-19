import type { User } from '@/components/security/SecurityProvider';

export class PermissionService {
  static canDelete(user: User | null): boolean {
    if (!user) return false;
    // IT Admin, QA Admin, general admin, and QA manager can delete
    const allowedRoles = ['admin', 'it_admin', 'qa_admin', 'manager', 'qc_manager'];
    return allowedRoles.includes(user.role) || (user.permissions && (user.permissions.includes('*') || user.permissions.includes('data.delete')));
  }

  static canRecover(user: User | null): boolean {
    if (!user) return false;
    const allowedRoles = ['admin', 'it_admin', 'qa_admin'];
    return allowedRoles.includes(user.role) || (user.permissions && (user.permissions.includes('*') || user.permissions.includes('data.recover')));
  }

  static canHardDelete(user: User | null): boolean {
    if (!user) return false;
    const allowedRoles = ['admin', 'it_admin', 'qa_admin'];
    return allowedRoles.includes(user.role) || (user.permissions && user.permissions.includes('*'));
  }
}
