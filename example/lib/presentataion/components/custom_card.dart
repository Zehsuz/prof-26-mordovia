import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:widgetbook/widgetbook.dart';

class CustomCardUseCase extends WidgetbookUseCase with CustomLogger {
  CustomCardUseCase()
    : super(name: 'CustomCard', builder: (_) => throw UnimplementedError());

  @override
  Widget build(BuildContext context) {
    logInfo('build() $runtimeType');
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .center,
      children: [
        SizedBox(
          width: 315.w,
          height: 169.h,
          child: CustomCard(
            child: Padding(
              padding: .only(top: 30.h, left: 24.w, right: 24.w, bottom: 24.h),
              child: Column(
                crossAxisAlignment: .stretch,
                spacing: 10.h,
                children: [
                  Text(
                    context.knobs.string(
                      label: 'Header',
                      initialValue: 'Schedule',
                    ),
                    style: CustomStyles.poppinsBold12.copyWith(
                      color: context.palette.white,
                      height: 18 / 12,
                      letterSpacing: -0.3.sp,
                    ),
                  ),
                  Text(
                    context.knobs.string(
                      label: 'Body',
                      initialValue: '''Easily schedule event/games
then find like minded players for battle. You up for it?''',
                    ),
                    style: CustomStyles.poppinsRegular10.copyWith(
                      color: context.palette.white,
                      height: 12 / 10,
                      letterSpacing: -0.3.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
