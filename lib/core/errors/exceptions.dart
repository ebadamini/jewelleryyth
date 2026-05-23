// core/errors/exceptions.dart
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error']);
}