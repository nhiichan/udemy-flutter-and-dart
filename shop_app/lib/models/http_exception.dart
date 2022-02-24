class HttpException implements Exception {
  // vì Exception là 1 abstract class => chỉ có thể implements
  // chứ không thể extends!

  final String message;

  HttpException(this.message);

  @override
  String toString() {
    // return super.toString(); // Instance of HttpException
    return message;
  }
}
