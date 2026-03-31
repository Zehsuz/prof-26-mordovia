import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';

/// Назначение: enum отвечает за иницилизацию всех состояний Input
/// Дата создание: 31.03.2026
/// Автор создания: 4
enum InputType { base, password }

/// Назначение: класс отвечает за определение элемента Input
/// Дата создание: 31.03.2026
/// Автор создания: 4
class CustomInput extends StatefulWidget with CustomLogger {
  final InputType type;
  final String hint;
  final TextEditingController controller;

  const CustomInput({
    super.key,
    required this.type,
    required this.hint,
    required this.controller,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

/// Назначение: класс отвечает за определение всех состояний Input
/// Дата создание: 31.03.2026
/// Автор создания: 4
class _CustomInputState extends State<CustomInput>
    with LoggableWidgetState, CustomLogger {
  late bool _isObscured = widget.type == .password ? true : false;

  @override
  Widget build(BuildContext context) {
    logInfo('build() ${widget.type}');
    return Column(
      spacing: 8.h,
      children: [
        Stack(
          alignment: .centerRight,
          children: [
            TextField(
              obscuringCharacter: '*',
              obscureText: _isObscured,
              controller: widget.controller,
              style: CustomStyles.poppinsRegular12.copyWith(
                color: context.palette.text,
                height: 18 / 12,
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: .zero,
                border: .none,
                enabledBorder: .none,
                focusedBorder: .none,
                hintText: widget.hint,
                hintStyle: CustomStyles.poppinsRegular12.copyWith(
                  color: context.palette.hint,
                  height: 18 / 12,
                ),
              ),
            ),
            if (widget.type == .password)
              Padding(
                padding: .symmetric(horizontal: 6.w),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                  child: Icon(
                    CustomIcons.eye,
                    color: context.palette.text,
                    size: 12.r,
                  ),
                ),
              ),
          ],
        ),
        Container(
          width: .infinity,
          height: 1.h,
          decoration: BoxDecoration(gradient: context.palette.mainGradient),
        ),
      ],
    );
  }
}
