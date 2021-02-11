class EncriptionException implements Exception {
  final String massage;
  EncriptionException(this.massage);

  String toString() {
    return this.massage;
  }
}
