import 'package:flutter/material.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:widgetbook/widgetbook.dart';

class CustomInputUseCase extends WidgetbookUseCase with CustomLogger {
  CustomInputUseCase()
    : super(name: 'CustomInput', builder: (_) => throw UnimplementedError());

  @override
  Widget build(BuildContext context) {
    logInfo('build() $runtimeType');
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .center,
      children: [
        CustomInput(
          type: context.knobs.object.dropdown(
            label: 'Input Type',
            options: InputType.values,
          ),
          hint: context.knobs.string(
            label: 'hint text',
            initialValue: 'hint text',
          ),
          controller: .new(
            text: context.knobs.string(
              label: 'controller text',
              initialValue: 'controller text',
            ),
          ),
        ),
      ],
    );
  }
}
