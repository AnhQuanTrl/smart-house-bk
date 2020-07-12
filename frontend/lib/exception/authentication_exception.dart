class AuthenticationException implements Exception {
  final String _message;

  AuthenticationException(this._message);

  String toString() {
    return _message;
  }
}
