import 'package:example/presentataion/components/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:widgetbook/widgetbook.dart';

class CustomButtonUseCase extends WidgetbookUseCase with CustomLogger {
  CustomButtonUseCase()
    : super(name: 'CustomButton', builder: (_) => throw UnimplementedError());

  @override
  Widget build(BuildContext context) {
    logInfo('build() $runtimeType');
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .center,
      children: [
        CustomButton(
          type: context.knobs.object.dropdown(
            label: 'Button Type',
            options: ButtonType.values,
          ),
          text: context.knobs.string(
            label: 'Text',
            initialValue: 'Text Button',
          ),
          onPressed: () {
            logInfo('onPressed!');
          },
          icon: Icon(
            context.knobs.object.dropdown(
              label: 'Icon',
              options: IconsUseCase().iconsMap.values.toList(),
            ),
            size: 18.r,
            color: context.palette.pinkText,
          ),
        ),
      ],
    );
  }
}
