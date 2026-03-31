import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/src/presentation/theme/extension.dart';
import 'package:ui_kit/ui_kit.dart';

/// Назначение: класс отвечает за определение CheckBox
/// Дата создание: 31.03.2026
/// Автор создания: 4
class CustomCheckBox extends StatefulWidget {
  final bool value;
  final Function(bool) onChanged;
  final String? text;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.text,
  });

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

/// Назначение: класс отвечает за определение всех состояний CheckBox
/// Дата создание: 31.03.2026
/// Автор создания: 4
class _CustomCheckBoxState extends State<CustomCheckBox>
    with CustomLogger, LoggableWidgetState {
  late bool _value = widget.value;

  @override
  Widget build(BuildContext context) {
    logInfo('build()');
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
          widget.onChanged(_value);
          logInfo('onChanged $_value');
        });
      },
      child: Row(
        mainAxisSize: .min,
        children: [
          Container(
            width: 14.r,
            height: 14.r,
            decoration: BoxDecoration(
              borderRadius: .circular(3.r),
              border: Border.all(color: context.palette.pinkText, width: 1.r),
            ),
            child: _value == true
                ? Center(
                    child: Icon(
                      CustomIcons.checkmark,
                      size: 7.r,
                      color: context.palette.pinkText,
                    ),
                  )
                : null,
          ),
          if (widget.text != null)
            Text(
              widget.text!,
              style: CustomStyles.poppinsRegular12.copyWith(
                color: context.palette.text,
                height: 18 / 12,
              ),
            ),
        ],
      ),
    );
  }
}
