import 'package:flutter/material.dart';

/// Назначение: класс отвечает за иницилизацию цветов приложения
/// Дата создание: 31.03.2026
/// Автор создания: 4
abstract class Palette {
  abstract final Color primaryPink;
  abstract final Color secondaryPink;
  abstract final Color text;
  abstract final Color white;
  abstract final Color pinkText;
  abstract final Color gold;
  abstract final Color silver;
  abstract final Color active;
  abstract final Color hint;
  abstract final Color closed;
  abstract final Color online;
  abstract final Color away;

  LinearGradient get mainGradient => LinearGradient(
    colors: [secondaryPink, primaryPink],
    begin: .topLeft,
    end: .bottomRight,
  );
}

/// Назначение: класс отвечает за определение цветов светлой темы приложения
/// Дата создание: 31.03.2026
/// Автор создания: 4
class LightPalette extends Palette {
  @override
  Color get active => Color(0xFF81F34B);

  @override
  Color get away => Color(0xFFFA8F2C);

  @override
  Color get closed => Color(0xFF8F8F8F);

  @override
  Color get gold => Color(0xFFF4C73E);

  @override
  Color get hint => Color(0xFFC9C9C9);

  @override
  Color get online => Color(0xFF08F403);

  @override
  Color get pinkText => Color(0xFFFA5075);

  @override
  Color get primaryPink => Color(0xFFF22E63);

  @override
  Color get secondaryPink => Color(0xFFFF6480);

  @override
  Color get silver => Color(0xFFB7B7B7);

  @override
  Color get text => Color(0xFF030303);

  @override
  Color get white => Color(0xFFFFFFFF);
}
