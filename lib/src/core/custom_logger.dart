import 'dart:developer';
import 'package:logging/logging.dart';

/// назначение: mixin отвечает за логирование любых элементов
/// создал: Захар
/// дата создания: 30.03.26
mixin CustomLogger {
  void logDebug(String message) {
    _log(message, level: .FINE);
  }

  void logInfo(String message) {
    _log(message, level: .INFO);
  }

  void logError(String message) {
    _log(message, level: .SEVERE);
  }

  void _log(String message, {required Level level}) {
    log(
      message,
      name: runtimeType.toString(),
      level: level.value,
      time: DateTime.timestamp(),
    );
  }
}
