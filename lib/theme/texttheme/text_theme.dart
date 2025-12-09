import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';

class AppTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    titleMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textDarkGray,
      fontStyle: FontStyle.normal,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textGray,
      fontStyle: FontStyle.normal,
    ),

    labelSmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textLightGray,
      fontStyle: FontStyle.normal,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textBlack,
      fontStyle: FontStyle.normal,
    ),

    headlineMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.textBlack,
      fontStyle: FontStyle.normal,
    ),
    displayLarge: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textBlack,
      fontStyle: FontStyle.normal,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textBlack,
      fontStyle: FontStyle.normal,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textGray,
      fontStyle: FontStyle.normal,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: AppColors.textBlack,
      fontStyle: FontStyle.normal,
    ),
  );

  static TextTheme darkTextTheme = TextTheme();
}
