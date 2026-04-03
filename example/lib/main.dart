import 'package:example/presentataion/widgets/app.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL; // Устанавливаем уровень логирования
  Logger.root.onRecord.listen((record) {
    print('[${record.loggerName}]: ${record.level.name} - ${record.message}');
  });
  runApp(App());
}



#  import 'package:appmetrica_plugin/appmetrica_plugin.dart'
#
#  void main() {
  #  AppMetrica.activate(AppMetricaConfig('b86fa748-764f-48d6-a4bf-4883732cf66f'));
  #
  #
  #}
#
#
#  void onTap() {
  #  AppMetrica.reportEvent('нажата кнопка регистрации');
  #}
#
#  пробуй билдить, если ошибка, то иди в  build/app/outputs/mapping/release/missing_rules.txt,
#  оттуда копируешь строчку(и) начинающиеся с -
#  создай файл android/app/proguard-rules.pro и вставь туда строчки
#
#  прожми pub get и потом билди еще раз
# https://docs.flutter.dev/deployment/android