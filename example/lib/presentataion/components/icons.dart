import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:widgetbook/widgetbook.dart';

class IconsUseCase extends WidgetbookUseCase with CustomLogger {
  IconsUseCase()
    : super(name: 'Icons', builder: (_) => throw UnimplementedError());
  final Map<String, IconData> iconsMap = {
    'location': CustomIcons.location,
    'settings': CustomIcons.settings,
    'comment': CustomIcons.comment,
    'language': CustomIcons.language,
    'scheduleBig': CustomIcons.scheduleBig,
    'arrowLeft': CustomIcons.arrowLeft,
    'arrowRight': CustomIcons.arrowRight,
    'eye': CustomIcons.eye,
    'profile': CustomIcons.profile,
    'logoutIcon': CustomIcons.logoutIcon,
    'checkmark': CustomIcons.checkmark,
    'arrowDown': CustomIcons.arrowDown,
    'close': CustomIcons.close,
    'brightness': CustomIcons.brightness,
    'text': CustomIcons.text,
    'search': CustomIcons.search,
    'scheduleSmall': CustomIcons.scheduleSmall,
    'tick1': CustomIcons.tick1,
    'arrowsRight': CustomIcons.arrowsRight,
    'clock': CustomIcons.clock,
  };

  @override
  Widget build(BuildContext context) {
    logInfo('build() $runtimeType');
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: .center,
        children: [
          for (var item in iconsMap.entries) ...{
            Text(item.key),
            Icon(item.value, size: 32.r, color: context.palette.text),
          },
        ],
      ),
    );
  }
}
