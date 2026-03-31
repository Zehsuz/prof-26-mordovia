import 'package:example/presentataion/components/custom_button.dart';
import 'package:example/presentataion/components/icons.dart';
import 'package:example/presentataion/components/palette.dart';
import 'package:example/presentataion/components/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:widgetbook/widgetbook.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        ViewportAddon([AndroidViewports.samsungGalaxyA50]),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData.light().copyWith(
                extensions: [CustomTheme(palette: LightPalette())],
              ),
            ),
          ],
        ),
        AlignmentAddon(),
      ],
      appBuilder: (context, child) =>
          ScreenUtilInit(designSize: .new(375, 812), child: child),
      directories: [
        WidgetbookPackage(
          name: 'UI-Kit',
          children: [
            WidgetbookFolder(name: 'Theme', children: [PaletteUseCase()]),
            WidgetbookFolder(
              name: 'Typography',
              children: [StylesUseCase(), IconsUseCase()],
            ),
            WidgetbookFolder(
              name: 'Widgets',
              children: [CustomButtonUseCase()],
            ),
          ],
        ),
      ],
    );
  }
}
