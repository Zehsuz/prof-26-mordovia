import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';

/// Назначение: класс отвечает за определение всех состояний Paginator
/// Дата создание: 31.03.2026
/// Автор создания: 4
class CustomPaginator extends StatelessWidget with CustomLogger {
  final int count;
  final int selectIndex;

  const CustomPaginator({
    super.key,
    required this.count,
    required this.selectIndex,
  });

  @override
  Widget build(BuildContext context) {
    logInfo('build()');
    return Row(
      spacing: 10.w,
      mainAxisSize: .min,
      children: [
        for (int i = 0; i < count; i++) ...{
          Container(
            width: 10.r,
            height: 10.r,
            decoration: BoxDecoration(
              color: i == selectIndex
                  ? context.palette.pinkText
                  : context.palette.pinkText.withAlpha(0x33),
              borderRadius: .circular(5.r),
            ),
          ),
        },
      ],
    );
  }
}
