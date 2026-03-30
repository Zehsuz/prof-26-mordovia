import 'package:flutter/material.dart';
import 'package:logger_helper/logger_helper.dart';

/// назначение: mixin отвечает за автоматическое логирование stateful виджетов
/// создал: Захар
/// дата создания: 30.03.26
mixin LoggableWidgetState<T extends StatefulWidget> on State<T>
    implements CustomLogger {
  @override
  void initState() {
    _log('initState()');
    super.initState();
  }

  @override
  void dispose() {
    _log('dispose()');
    super.dispose();
  }

  @override
  void deactivate() {
    _log('deactivate()');
    super.deactivate();
  }

  void _log(String message) {
    logInfo(message);
  }
}

/// назначение: mixin отвечает за логирование жизненного цикла экранов
/// создал: Захар
/// дата создания: 30.03.26
mixin LoggablePageState on LoggableWidgetState {
  @override
  void _log(String message) {
    logInfo(message);
  }
}
