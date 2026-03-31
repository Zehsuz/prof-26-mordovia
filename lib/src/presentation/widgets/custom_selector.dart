import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';

/// Назначение: класс отвечает за иницилизацию Selector
/// Дата создание: 31.03.2026
/// Автор создания: 4
class CustomSelector extends StatefulWidget {
  final String text;
  final List<String> items;
  final bool? accented;

  const CustomSelector({
    super.key,
    required this.text,
    required this.items,
    this.accented,
  });

  @override
  State<CustomSelector> createState() => _CustomSelectorState();
}
/// Назначение: класс отвечает за определение всех состояний Selector
/// Дата создание: 31.03.2026
/// Автор создания: 4
class _CustomSelectorState extends State<CustomSelector>
    with LoggableWidgetState, CustomLogger {
  late String text = widget.text;

  @override
  Widget build(BuildContext context) {
    logInfo('build()');
    return Column(
      crossAxisAlignment: .start,
      mainAxisAlignment: .start,
      mainAxisSize: .min,
      spacing: 8.h,
      children: [
        GestureDetector(
          onTap: () {
            showBottomSheet(
              context: context,
              builder: (context) => CustomBottomSheet(
                items: widget.items,
                onSelect: (item) {
                  logInfo('select $item');
                  setState(() {
                    text = item.toString();
                  });
                },
              ),
            );
            logInfo('onPressed!');
          },
          child: Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .end,
            children: [
              Text(widget.text),
              Padding(
                padding: .only(bottom: 4.h, right: 6.w),
                child: Icon(
                  CustomIcons.arrowDown,
                  size: 8.r,
                  color: context.palette.pinkText,
                ),
              ),
            ],
          ),
        ),
        if(widget.accented == true)
        Container(
          width: .infinity,
          height: 1.h,
          decoration: BoxDecoration(gradient: context.palette.mainGradient),
        ),
      ],
    );
  }
}
