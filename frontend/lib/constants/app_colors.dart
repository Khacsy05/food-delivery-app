import 'package:flutter/material.dart';

/// Design Tokens tuân thủ nghiêm ngặt file design-system/foodapp/MASTER.md
class AppColors {
  // Brand Colors (Xanh Mint Tươi Mát - Baemin / UberEats)
  static const Color primary = Color(0xFF2AC1BC);       // #2AC1BC (Xanh Mint tươi sáng, biểu tượng ẩm thực hiện đại)
  static const Color secondary = Color(0xFF109C98);     // #109C98 (Xanh Teal sẫm sang trọng)
  static const Color accent = Color(0xFFFFFFFF);        // #FFFFFF (Nút CTA Trắng tinh khôi trên nền banner)
  static const Color onAccent = Color(0xFF109C98);      // #109C98 (Chữ Teal sẫm trên nền nút trắng)

  // Background & Surfaces
  static const Color background = Color(0xFFF8FAFC);    // #F8FAFC (Nền Slate sáng sạch sẽ)
  static const Color foreground = Color(0xFF0F172A);    // #0F172A (Đen than hiện đại, tương phản cao)
  static const Color card = Color(0xFFFFFFFF);          // #FFFFFF
  static const Color cardForeground = Color(0xFF0F172A);
  static const Color muted = Color(0xFFF1F5F9);         // #F1F5F9
  static const Color mutedForeground = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);        // #E2E8F0

  // Status & Feedback
  static const Color destructive = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color ring = Color(0xFF2AC1BC);

  // Backwards compatibility aliases
  static const Color surface = card;
  static const Color textPrimary = foreground;
  static const Color textSecondary = mutedForeground;
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color error = destructive;
  static const Color primaryDark = secondary;
}
