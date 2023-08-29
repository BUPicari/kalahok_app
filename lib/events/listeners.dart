import 'package:kalahok_app/events/bus.dart';
import 'package:kalahok_app/events/logger_event.dart';

class Listeners {
  static loggerEventListener(String log) {
    eventBus.on<LoggerEvent>().listen((event) {
      print(event.log);
    });

    eventBus.fire(LoggerEvent(log));
  }
}
