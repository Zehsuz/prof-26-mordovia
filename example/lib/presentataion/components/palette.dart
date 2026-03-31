import 'package:flutter/material.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widgetbook/widgetbook.dart';

class PaletteUseCase extends WidgetbookUseCase with CustomLogger {
  PaletteUseCase()
    : super(name: 'Palette', builder: (_) => throw UnimplementedError());

  @override
  Widget build(BuildContext context) {
    logInfo('build() $runtimeType');
    final Map<String, dynamic> colorsMap = {
      'primaryPink': context.palette.primaryPink,
      'secondaryPink': context.palette.secondaryPink,
      'text': context.palette.text,
      'white': context.palette.white,
      'pinkText': context.palette.pinkText,
      'gold': context.palette.gold,
      'silver': context.palette.silver,
      'active': context.palette.active,
      'hint': context.palette.hint,
      'closed': context.palette.closed,
      'online': context.palette.online,
      'away': context.palette.away,
    };
    final Map<String, dynamic> gradientsMap = {
      'mainGradient': context.palette.mainGradient,
    };
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: .center,
        children: [
          for (var item in colorsMap.entries) ...{
            Text(item.key),
            Container(width: 100.r, height: 100.r, color: item.value),
          },
          for (var item in gradientsMap.entries) ...{
            Text(item.key),
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(gradient: item.value),
            ),
          },
        ],
      ),
    );
  }
}
