import 'package:flutter/material.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:widgetbook/widgetbook.dart';

class CustomCheckBoxUseCase extends WidgetbookUseCase with CustomLogger {
  CustomCheckBoxUseCase()
    : super(name: 'CustomCheckBox', builder: (_) => throw UnimplementedError());

  @override
  Widget build(BuildContext context) {
    logInfo('build() $runtimeType');
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .center,
      children: [
        CustomCheckBox(
          value: context.knobs.boolean(label: 'Value'),
          onChanged: (bool p1) {
            logInfo('onChanged!');
          },
        ),
      ],
    );
  }
}
