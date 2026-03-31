import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/src/presentation/theme/extension.dart';
import 'package:ui_kit/ui_kit.dart';

/// Назначение: класс отвечает за определение всех состояний Timer
/// Дата создание: 31.03.2026
/// Автор создания: 4
class CustomTimer extends StatelessWidget with CustomLogger {
  final String hour;
  final String min;

  const CustomTimer({super.key, required this.hour, required this.min});

  @override
  Widget build(BuildContext context) {
    logInfo('build()');
    return CustomCard(
      child: Padding(
        padding: .only(top: 7.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: .center,
          spacing: 14.h,
          children: [
            Text(
              'Timer',
              style: CustomStyles.poppinsRegular12.copyWith(
                color: context.palette.white,
                height: 18 / 12,
                letterSpacing: 0.3.sp,
              ),
            ),
            Text(
              '${hour != '0' ? hour : "00"}:${min != '0' ? min : "00"}',
              style: CustomStyles.poppinsBold30.copyWith(
                color: context.palette.white,
                height: 45 / 30,
                letterSpacing: 0.3.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
