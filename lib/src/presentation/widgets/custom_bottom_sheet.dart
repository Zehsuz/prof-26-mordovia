import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger_helper/logger_helper.dart';
import 'package:ui_kit/ui_kit.dart';

/// Назначение: класс отвечает за определение всех состояний BottomSheet
/// Дата создание: 31.03.2026
/// Автор создания: 4
class CustomBottomSheet extends StatelessWidget with CustomLogger {
  final List<String> items;
  final Function(String) onSelect;

  CustomBottomSheet({
    super.key,
    required this.items,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    logInfo('build()');
    return Container(
      width: .infinity,
      height: 400.h,
      decoration: BoxDecoration(
        color: context.palette.secondaryPink,
        borderRadius: .only(
          topLeft: .circular(10.r),
          topRight: .circular(10.r),
        ),
      ),
      child: Padding(
        padding: .all(10.r),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (var item in items) ...{
                GestureDetector(
                  onTap: () {
                    onSelect(item);
                    logInfo('onSelect $item');
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: context.palette.white,
                    width: .infinity,
                    child: Padding(padding: .all(10.r), child: Text(item)),
                  ),
                ),
                Divider(),
              },
            ],
          ),
        ),
      ),
    );
  }
}
