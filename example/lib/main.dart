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
