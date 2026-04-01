import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/src/presentation/theme/extension.dart';
import 'package:ui_kit/ui_kit.dart';

/// Назначение: класс отвечает за определение всех состояний Card
/// Дата создание: 31.03.2026
/// Автор создания: 4
class CustomCard extends StatelessWidget with CustomLogger {
  final Widget child;

  CustomCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    logInfo('build()');
    return Container(
      decoration: BoxDecoration(
        borderRadius: .circular(10.r),
        gradient: context.palette.mainGradient,
      ),
      child: child,
    );
  }
}
