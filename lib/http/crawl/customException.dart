class CustomException implements Exception {
  int code;
  String message;
  var payload;
  CustomException(this.code, this.message, [this.payload]);

  @override
  String toString() => '$message';
}
