import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:widgetbook/widgetbook.dart';

class CustomTimerUseCase extends WidgetbookUseCase with CustomLogger {
  CustomTimerUseCase()
    : super(name: 'CustomTimer', builder: (_) => throw UnimplementedError());

  @override
  Widget build(BuildContext context) {
    logInfo('build() $runtimeType');
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .center,
      children: [
        SizedBox(
          width: 295.w,
          height: 100.h,
          child: CustomTimer(
            hour: context.knobs.int
                .slider(label: 'Hour', max: 60, min: 0, initialValue: 0)
                .toString(),
            min: context.knobs.int
                .slider(label: 'Min', max: 59, min: 0, initialValue: 0)
                .toString(),
          ),
        ),
      ],
    );
  }
}
