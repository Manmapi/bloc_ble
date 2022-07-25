

class BleLogger {
    List<String> _logger = <String> [];

    void addLooger(String message)
    {
      _logger.add('${DateTime.now().toString().substring(0,19)}  $message');
    }

    List<String> get logger => _logger;

}