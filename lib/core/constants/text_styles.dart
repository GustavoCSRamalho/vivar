// core/constants/text_styles.dart
import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // Fonte padrão
  static const String fontFamily = 'Inter';

  // ========== TÍTULOS ==========

  // H1 - Títulos principais
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  // H2 - Títulos secundários
  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: -0.3,
  );

  // H3 - Títulos terciários
  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: -0.2,
  );

  // ========== SUBTÍTULOS ==========

  // Subtitle - Para subtítulos e destaques
  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Subtitle 2
  static const TextStyle subtitle2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // ========== CORPO DE TEXTO ==========

  // Body - Texto principal
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // Body Small - Texto secundário
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // Body Medium - Texto com peso médio
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // Body Bold - Texto em negrito
  static const TextStyle bodyBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // ========== CAPTIONS E LABELS ==========

  // Caption - Texto pequeno (legendas, notas)
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Caption Bold
  static const TextStyle captionBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Overline - Texto muito pequeno (labels, categorias)
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.6,
    letterSpacing: 1.5,
  );

  // ========== BOTÕES ==========

  // Button - Texto de botões
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // Button Small
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // Button Large
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // ========== INPUTS ==========

  // Input - Texto de campos de entrada
  static const TextStyle input = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // Input Label
  static const TextStyle inputLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Input Hint
  static const TextStyle inputHint = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Input Error
  static const TextStyle inputError = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
    height: 1.4,
  );

  // ========== ESPECIAIS ==========

  // Link - Para links e textos clicáveis
  static const TextStyle link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.5,
    decoration: TextDecoration.underline,
  );

  // Link Small
  static const TextStyle linkSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.5,
    decoration: TextDecoration.underline,
  );

  // Price - Para preços e valores monetários
  static const TextStyle price = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1.2,
  );

  // Price Small
  static const TextStyle priceSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1.2,
  );

  // Number - Para números e contadores
  static const TextStyle number = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // Number Small
  static const TextStyle numberSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // ========== BADGES E CHIPS ==========

  // Badge - Para badges e tags
  static const TextStyle badge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // Chip
  static const TextStyle chip = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // ========== MÉTODOS AUXILIARES ==========

  // Método para criar variações de cor
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  // Método para criar variações de peso
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  // Método para criar variações de tamanho
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  // ========== VARIAÇÕES PRÉ-DEFINIDAS ==========

  // Texto com cor secundária
  static TextStyle secondary(TextStyle style) {
    return style.copyWith(color: AppColors.textSecondary);
  }

  // Texto com cor primária (laranja)
  static TextStyle primary(TextStyle style) {
    return style.copyWith(color: AppColors.primary);
  }

  // Texto branco
  static TextStyle white(TextStyle style) {
    return style.copyWith(color: Colors.white);
  }

  // Texto com cor de sucesso
  static TextStyle success(TextStyle style) {
    return style.copyWith(color: AppColors.success);
  }

  // Texto com cor de erro
  static TextStyle error(TextStyle style) {
    return style.copyWith(color: AppColors.error);
  }

  // Texto com cor de aviso/alerta
  static TextStyle warning(TextStyle style) {
    return style.copyWith(color: AppColors.accent);
  }

  // ========== THEME DATA ==========

  // Método para criar TextTheme do Material
  static TextTheme getTextTheme() {
    return TextTheme(
      displayLarge: h1,
      displayMedium: h2,
      displaySmall: h3,
      headlineMedium: subtitle,
      headlineSmall: subtitle2,
      titleLarge: bodyBold,
      titleMedium: bodyMedium,
      titleSmall: bodySmall,
      bodyLarge: body,
      bodyMedium: bodySmall,
      bodySmall: caption,
      labelLarge: button,
      labelMedium: buttonSmall,
      labelSmall: badge,
    );
  }
}

// ========== EXTENSÕES ÚTEIS ==========

extension TextStyleExtensions on TextStyle {
  // Adicionar opacidade
  TextStyle withOpacity(double opacity) {
    return copyWith(color: color?.withOpacity(opacity));
  }

  // Adicionar altura de linha
  TextStyle withHeight(double height) {
    return copyWith(height: height);
  }

  // Adicionar espaçamento entre letras
  TextStyle withLetterSpacing(double spacing) {
    return copyWith(letterSpacing: spacing);
  }

  // Tornar itálico
  TextStyle italic() {
    return copyWith(fontStyle: FontStyle.italic);
  }

  // Adicionar sublinhado
  TextStyle underline() {
    return copyWith(decoration: TextDecoration.underline);
  }

  // Adicionar linha sobreposta
  TextStyle lineThrough() {
    return copyWith(decoration: TextDecoration.lineThrough);
  }

  // Tornar maiúsculo visualmente (não altera o texto)
  TextStyle uppercase() {
    return copyWith(letterSpacing: 1.5);
  }
}
