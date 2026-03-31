import 'package:flutter/material.dart';
import 'package:ui_kit/src/presentation/theme/palette.dart';

/// Назначение: класс отвечает за определение темы приложение
/// Дата создание: 31.03.2026
/// Автор создания: 4
class CustomTheme extends ThemeExtension<CustomTheme> {
  final Palette palette;

  CustomTheme({required this.palette});

  @override
  ThemeExtension<CustomTheme> copyWith() {
    return this;
  }

  @override
  ThemeExtension<CustomTheme> lerp(
    covariant ThemeExtension<CustomTheme>? other,
    double t,
  ) {
    return this;
  }

  static CustomTheme of(BuildContext context) =>
      Theme.of(context).extension<CustomTheme>()!;
}

/// Назначение: класс отвечает за добавление цветов из palette в приложения
/// Дата создание: 31.03.2026
/// Автор создания: 4
extension CustomThemeExt on BuildContext {
  Palette get palette => CustomTheme.of(this).palette;
}
