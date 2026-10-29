import 'package:flutter/material.dart';

class AppTheme{
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.black,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        onPrimary: AppColors.black,
        secondary: AppColors.goldLight,
        onSecondary: AppColors.black,
        surface: AppColors.dark2,
        onSurface: AppColors.text,
        error: AppColors.red,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.goldLight,
          side: const BorderSide(color: AppColors.borderHover, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textLight,
        size: 22,
      ),
    );
  }
}
class AppColors {
  AppColors._(); 

  static const Color gold = Color(0xFFC9A84C);
  static const Color goldLight = Color(0xFFE8C97A);
  static const Color goldPale = Color(0xFFF5E4B0);
  static const Color goldDark = Color(0xFF8A6A20);

  static const Color black = Color(0xFF080808);
  static const Color dark = Color(0xFF0E0E0E);
  static const Color dark2 = Color(0xFF141414);
  static const Color dark3 = Color(0xFF1C1C1C);
  static const Color dark4 = Color(0xFF242424);

  static const Color text = Color(0xFFF0E8D0);
  static const Color textMuted = Color(0xFF8A7A5A);
  static const Color textLight = Color(0xFFC8B888);

  static const Color red = Color(0xFFCC4444);
  static const Color green = Color(0xFF3A8A3A);
  static const Color blue = Color(0xFF3A6ACA);

 
  static const Color border = Color(0x2EC9A84C);       
  static const Color borderHover = Color(0x73C9A84C); 
}