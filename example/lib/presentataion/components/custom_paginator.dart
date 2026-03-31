import 'package:flutter/material.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:widgetbook/widgetbook.dart';

class CustomPaginatorUseCase extends WidgetbookUseCase with CustomLogger {
  CustomPaginatorUseCase()
      : super(
    name: 'CustomPaginator',
    builder: (_) => throw UnimplementedError(),
  );

  @override
  Widget build(BuildContext context) {
    logInfo('build() $runtimeType');
    final count = context.knobs.int.slider(label: 'Count', initialValue: 3);
    return CustomPaginator(
      count: count,
      selectIndex: context.knobs.int.slider(
        label: 'SelectIndex',
        initialValue: 2,
        max: count-1,
      ),
    );
  }
}