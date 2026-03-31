import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:widgetbook/widgetbook.dart';

class CustomBottomSheetUseCase extends WidgetbookUseCase with CustomLogger {
  CustomBottomSheetUseCase()
    : super(
        name: 'CustomBottomSheet',
        builder: (_) => throw UnimplementedError(),
      );

  @override
  Widget build(BuildContext context) {
    logInfo('build() $runtimeType');
    return Column(
      mainAxisSize: .min,
      spacing: 10.h,
      children: [
        CustomBottomSheet(
          items: [
            for (
              int i = 0;
              i < context.knobs.int.slider(label: 'count', initialValue: 4);
              i++
            ) ...{
              context.knobs.string(label: 'TextItem', initialValue: 'text'),
            },
          ],
          onSelect: (item) {
            logInfo('select $item');
          },
        ),
      ],
    );
  }
}
