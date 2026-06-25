import 'package:flutter/material.dart';

class AppColors {
  static final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);

  static bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;

  static Color get primary => const Color(0xFF25A9E0);
  static Color get secondary => const Color(0xFF6B7280);
  static Color get success => const Color(0xFF10B981);
  static Color get warning => const Color(0xFFF59E0B);
  static Color get error => const Color(0xFFE11D48);
  
  static Color get background => isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFFAFAFA);
  static Color get surface => isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);
  
  static Color get textPrimary => isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF111827);
  static Color get textSecondary => isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
  
  static Color get border => isDarkMode ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
  
  // Icon background tints
  static Color get iconBgBlue => isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF);
  static Color get iconBlue => const Color(0xFF3B82F6);
  
  static Color get iconBgPurple => isDarkMode ? const Color(0xFF0C3547) : const Color(0xFFE8F6FC);
  static Color get iconPurple => const Color(0xFF25A9E0);
  
  static Color get iconBgGreen => isDarkMode ? const Color(0xFF064E3B) : const Color(0xFFECFDF5);
  static Color get iconGreen => const Color(0xFF10B981);
  
  static Color get iconBgOrange => isDarkMode ? const Color(0xFF78350F) : const Color(0xFFFFFBEB);
  static Color get iconOrange => const Color(0xFFF59E0B);
}
