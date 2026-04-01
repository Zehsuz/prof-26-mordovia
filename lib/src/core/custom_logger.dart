import 'package:logging/logging.dart';

/// назначение: mixin отвечает за логирование любых элементов
/// создал: Захар
/// дата создания: 30.03.26
mixin CustomLogger {
  late final _logging = Logger(runtimeType.toString());
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
    _logging.log(
      level,
      message,
    );
  }
}


///   how to use
///   main(){
///    Logger.root.level = Level.ALL; // Устанавливаем уровень логирования
///     Logger.root.onRecord.listen((record) {
///       print('[${record.loggerName}]: ${record.level.name} - ${record.message}');
///     });
///
///     //other code
///   }