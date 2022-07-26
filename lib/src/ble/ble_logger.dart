

import 'dart:async';

class BleLogger {
    final List<String> _logger = <String> [];

    void addLooger(String message)
    {
      _logger.add('${DateTime.now().toString().substring(0,19)}  $message');
      _loggerController.sink.add(logger);
      print(logger);
    }

    List<String> get logger => _logger;

    //Logger stream

    final StreamController <List<String>> _loggerController = StreamController();

    Stream<List<String>> get loggerState => _loggerController.stream;

    Future<void> dispose () async {
        await _loggerController.close();
    }
}