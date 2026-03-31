import 'package:flutter/material.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:widgetbook/widgetbook.dart';

class CustomSelectorUseCase extends WidgetbookUseCase with CustomLogger {
  CustomSelectorUseCase()
    : super(name: 'CustomSelector', builder: (_) => throw UnimplementedError());

  @override
  Widget build(BuildContext context) {
    logInfo('build() $runtimeType');
    return Scaffold(
      body: Builder(
        builder: (context) => Column(
          mainAxisAlignment: .center,
          children: [
            CustomSelector(
              text: context.knobs.string(label: 'Text', initialValue: 'text'),
              items: [
                for (
                  int i = 0;
                  i < context.knobs.int.slider(label: 'count', initialValue: 4);
                  i++
                ) ...{
                  context.knobs.string(label: 'TextItem', initialValue: 'text'),
                },
              ],
              accented: context.knobs.boolean(
                label: 'Accented',
                initialValue: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
