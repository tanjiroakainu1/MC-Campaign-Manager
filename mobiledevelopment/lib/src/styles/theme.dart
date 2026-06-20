import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const brand50 = Color(0xFFEEF4FC);
  static const brand100 = Color(0xFFD9E6F7);
  static const brand200 = Color(0xFFB3CDEF);
  static const brand500 = Color(0xFF2B6CB8);
  static const brand600 = Color(0xFF1E5599);
  static const brand700 = Color(0xFF164478);
  static const brand800 = Color(0xFF0C2657);
  static const brand900 = Color(0xFF081B3E);
  static const diamond100 = Color(0xFFE0F4FA);
  static const diamond200 = Color(0xFFB8E4F2);
  static const diamond400 = Color(0xFF5BB8D4);
  static const diamond500 = Color(0xFF3A9BBF);
  static const diamond600 = Color(0xFF2A7A99);
  static const surface = Color(0xFFF8FAFC);
  static const slate500 = Color(0xFF64748B);
  static const slate700 = Color(0xFF334155);
  static const slate900 = Color(0xFF0F172A);
}

ThemeData buildAppTheme() {
  const radius = 14.0;
  const cardRadius = 16.0;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brand600,
      primary: AppColors.brand600,
      secondary: AppColors.diamond500,
      surface: AppColors.surface,
      onSurface: AppColors.slate900,
    ),
    scaffoldBackgroundColor: AppColors.surface,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.brand800,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
        side: const BorderSide(color: AppColors.brand100),
      ),
      color: Colors.white,
      shadowColor: AppColors.brand600.withValues(alpha: 0.08),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.brand100, thickness: 1, space: 1),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      iconColor: AppColors.brand600,
      textColor: AppColors.slate900,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hoverColor: AppColors.brand50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: const BorderSide(color: AppColors.brand100)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: const BorderSide(color: AppColors.brand100)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: const BorderSide(color: AppColors.brand500, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: Colors.red.shade300)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: const TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w500),
      hintStyle: const TextStyle(color: AppColors.slate500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brand600,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.brand700,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        side: const BorderSide(color: AppColors.brand200),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.brand600,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.brand50,
      selectedColor: AppColors.brand100,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.brand800),
      side: const BorderSide(color: AppColors.brand100),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius))),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      backgroundColor: AppColors.brand800,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.brand600,
      linearTrackColor: AppColors.brand100,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.slate900, letterSpacing: -0.3),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.slate900),
      titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.slate900),
      bodyLarge: TextStyle(fontSize: 15, color: AppColors.slate700, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.slate700, height: 1.45),
      bodySmall: TextStyle(fontSize: 12, color: AppColors.slate500, height: 1.4),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.brand700),
    ),
    fontFamily: 'Roboto',
  );
}

Color statusColor(String status) {
  switch (status) {
    case 'active':
    case 'approved':
    case 'success':
      return AppColors.brand600;
    case 'pending':
    case 'warning':
      return AppColors.diamond600;
    case 'rejected':
    case 'inactive':
      return Colors.red.shade700;
    default:
      return AppColors.slate500;
  }
}
