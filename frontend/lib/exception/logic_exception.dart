class LogicException implements Exception {
  final String _message;

  LogicException(this._message);

  String toString() {
    return _message;
  }
}
