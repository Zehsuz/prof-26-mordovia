import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/src/presentation/theme/extension.dart';
import 'package:ui_kit/ui_kit.dart';

/// Назначение: enum отвечает за иницилизацию всех состояний Button
/// Дата создание: 31.03.2026
/// Автор создания: 4
enum ButtonType { filled, iconText }

/// Назначение: класс отвечает за определение всех состояний Button
/// Дата создание: 31.03.2026
/// Автор создания: 4
class CustomButton extends StatelessWidget with CustomLogger {
  final ButtonType type;
  final String text;
  final Icon? icon;
  final Function()? onPressed;

  const CustomButton({
    super.key,
    required this.type,
    required this.text,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    logInfo('build() $type');
    return switch (type) {
      ButtonType.filled => GestureDetector(
        onTap: () {
          onPressed;
          logInfo('onPressed $type!');
        },
        child: Container(
          width: 210.w,
          decoration: BoxDecoration(
            borderRadius: .circular(100.r),
            gradient: context.palette.mainGradient,
          ),
          child: Padding(
            padding: .all(19.r),
            child: Center(
              child: Text(
                text,
                style: CustomStyles.poppinsBold14.copyWith(
                  color: context.palette.white,
                  height: 21 / 14,
                ),
              ),
            ),
          ),
        ),
      ),
      ButtonType.iconText => GestureDetector(
        onTap: () {
          onPressed;
          logInfo('onPressed $type!');
        },
        child: Row(
          mainAxisSize: .min,
          crossAxisAlignment: .center,
          spacing: 18.w,
          children: [
            icon!,
            Text(
              text,
              style: CustomStyles.poppinsRegular16.copyWith(
                color: context.palette.text,
                height: 24 / 16,
              ),
            ),
          ],
        ),
      ),
    };
  }
}
