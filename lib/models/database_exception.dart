class DatabaseException implements Exception {
  final String massage;
  DatabaseException(this.massage);

  String toString() {
    return this.massage;
  }
}
