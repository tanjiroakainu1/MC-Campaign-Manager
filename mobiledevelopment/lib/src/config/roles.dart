import 'package:flutter/material.dart';
import '../styles/theme.dart';
import '../types/index.dart';

export '../types/index.dart' show UserRoles;

const roleLabels = {
  UserRoles.superAdmin: 'Super Admin',
  UserRoles.marketingManager: 'Marketing Manager',
  UserRoles.contentCreator: 'Content Creator',
  UserRoles.marketingAnalyst: 'Marketing Analyst',
};

/// Roles users may self-select at registration — Super Admin is admin-assigned only.
const registrationRoles = [
  UserRoles.marketingManager,
  UserRoles.contentCreator,
  UserRoles.marketingAnalyst,
];

Map<String, String> get registrationRoleLabels => Map.fromEntries(
  registrationRoles.map((role) => MapEntry(role, roleLabels[role]!)),
);

bool isRegistrationRole(String role) => registrationRoles.contains(role);

const roleDashboardPaths = {
  UserRoles.superAdmin: '/super-admin',
  UserRoles.marketingManager: '/marketing-manager',
  UserRoles.contentCreator: '/content-creator',
  UserRoles.marketingAnalyst: '/marketing-analyst',
};

String getDashboardPath(String role) => roleDashboardPaths[role] ?? '/login';
String getRoleLabel(String role) => roleLabels[role] ?? role;

class RoleBadgeColors {
  final Color background;
  final Color foreground;
  final Color? border;
  const RoleBadgeColors({required this.background, required this.foreground, this.border});
}

const roleColors = {
  UserRoles.superAdmin: RoleBadgeColors(background: Color(0x1A164478), foreground: AppColors.brand900, border: AppColors.brand200),
  UserRoles.marketingManager: RoleBadgeColors(background: AppColors.brand100, foreground: AppColors.brand800),
  UserRoles.contentCreator: RoleBadgeColors(background: AppColors.diamond100, foreground: AppColors.diamond600),
  UserRoles.marketingAnalyst: RoleBadgeColors(background: AppColors.brand50, foreground: AppColors.brand700, border: AppColors.brand200),
};

Widget roleBadge(String role) {
  final colors = roleColors[role] ?? RoleBadgeColors(background: const Color(0xFFF1F5F9), foreground: AppColors.slate700);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: colors.background,
      borderRadius: BorderRadius.circular(999),
      border: colors.border != null ? Border.all(color: colors.border!) : Border.all(color: colors.foreground.withValues(alpha: 0.12)),
    ),
    child: Text(getRoleLabel(role), style: TextStyle(color: colors.foreground, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.2)),
  );
}

class RoleQuickAccessStyle {
  final Color cardBorder;
  final Color cardBackground;
  final Gradient iconGradient;
  final Color buttonBackground;
  final Color buttonForeground;
  const RoleQuickAccessStyle({
    required this.cardBorder,
    required this.cardBackground,
    required this.iconGradient,
    required this.buttonBackground,
    required this.buttonForeground,
  });
}

const roleQuickAccess = {
  UserRoles.superAdmin: RoleQuickAccessStyle(
    cardBorder: Color(0xCC93C5FD),
    cardBackground: Color(0xB3EEF4FC),
    iconGradient: LinearGradient(colors: [AppColors.brand800, AppColors.brand900]),
    buttonBackground: AppColors.brand900,
    buttonForeground: Colors.white,
  ),
  UserRoles.marketingManager: RoleQuickAccessStyle(
    cardBorder: Color(0xCCBFDBFE),
    cardBackground: Color(0x99EEF4FC),
    iconGradient: LinearGradient(colors: [AppColors.brand500, AppColors.brand700]),
    buttonBackground: AppColors.brand600,
    buttonForeground: Colors.white,
  ),
  UserRoles.contentCreator: RoleQuickAccessStyle(
    cardBorder: Color(0xCCB8E4F2),
    cardBackground: Color(0x99E0F4FA),
    iconGradient: LinearGradient(colors: [AppColors.diamond400, AppColors.brand500]),
    buttonBackground: AppColors.diamond500,
    buttonForeground: Colors.white,
  ),
  UserRoles.marketingAnalyst: RoleQuickAccessStyle(
    cardBorder: Color(0xCCB8E4F2),
    cardBackground: Color(0x80E0F4FA),
    iconGradient: LinearGradient(colors: [AppColors.diamond200, AppColors.diamond500]),
    buttonBackground: AppColors.diamond600,
    buttonForeground: Colors.white,
  ),
};

class RoleSidebarAccent {
  final Gradient activeGradient;
  final Color iconColor;
  const RoleSidebarAccent({required this.activeGradient, required this.iconColor});
}

const roleSidebarAccent = {
  UserRoles.superAdmin: RoleSidebarAccent(
    activeGradient: LinearGradient(colors: [AppColors.brand800, AppColors.brand900]),
    iconColor: AppColors.brand800,
  ),
  UserRoles.marketingManager: RoleSidebarAccent(
    activeGradient: LinearGradient(colors: [AppColors.brand600, AppColors.brand800]),
    iconColor: AppColors.brand600,
  ),
  UserRoles.contentCreator: RoleSidebarAccent(
    activeGradient: LinearGradient(colors: [AppColors.diamond500, AppColors.brand600]),
    iconColor: AppColors.diamond600,
  ),
  UserRoles.marketingAnalyst: RoleSidebarAccent(
    activeGradient: LinearGradient(colors: [AppColors.diamond400, AppColors.brand500]),
    iconColor: AppColors.diamond600,
  ),
};

const roleActionAccent = {
  UserRoles.superAdmin: LinearGradient(colors: [AppColors.brand100, AppColors.brand200]),
  UserRoles.marketingManager: LinearGradient(colors: [AppColors.brand100, Color(0xFF9BBFE8)]),
  UserRoles.contentCreator: LinearGradient(colors: [AppColors.diamond100, AppColors.diamond200]),
  UserRoles.marketingAnalyst: LinearGradient(colors: [AppColors.diamond100, AppColors.brand200]),
};
