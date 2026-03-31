import 'package:flutter/material.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:widgetbook/widgetbook.dart';

class StylesUseCase extends WidgetbookUseCase with CustomLogger {
  StylesUseCase()
    : super(name: 'Fonts', builder: (_) => throw UnimplementedError());
  late final Map<String, TextStyle> _fontsMap = {
    'poppinsBold30': CustomStyles.poppinsBold30,
    'poppinsBold24': CustomStyles.poppinsBold24,
    'poppinsBold22': CustomStyles.poppinsBold22,
    'poppinsBold20': CustomStyles.poppinsBold20,
    'poppinsRegular18': CustomStyles.poppinsRegular18,
    'poppinsBold17': CustomStyles.poppinsBold17,
    'poppinsBold16': CustomStyles.poppinsBold16,
    'poppinsRegular16': CustomStyles.poppinsRegular16,
    'poppinsBold14': CustomStyles.poppinsBold14,
    'poppinsRegular14': CustomStyles.poppinsRegular14,
    'poppinsBold12': CustomStyles.poppinsBold12,
    'poppinsRegular12': CustomStyles.poppinsRegular12,
    'poppinsBold10': CustomStyles.poppinsBold10,
    'poppinsRegular10': CustomStyles.poppinsRegular10,
    'poppinsBold9': CustomStyles.poppinsBold9,
    'poppinsBold8': CustomStyles.poppinsBold8,
    'poppinsRegular8': CustomStyles.poppinsRegular8,
    'poppinsBold6': CustomStyles.poppinsBold6,
    'poppinsRegular6': CustomStyles.poppinsRegular6,
    'poppinsRegular4': CustomStyles.poppinsRegular4,
  };

  @override
  Widget build(BuildContext context) {
    logInfo('build() $runtimeType');
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: .center,
        children: [
          for (var item in _fontsMap.entries) ...{
            Text(item.key, style: item.value),
          },
        ],
      ),
    );
  }
}
