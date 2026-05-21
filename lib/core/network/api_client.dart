import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../storage/secure_token_storage.dart'; // ایمپورت مهم

class ApiClient {
  ApiClient({
    http.Client? client,
    String? baseUrl,
    required SecureTokenStorage tokenStorage, // اضافه شدن پارامتر اجباری
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConstants.apiBaseUrl,
        _tokenStorage = tokenStorage;

  final http.Client _client;
  final String _baseUrl;
  final SecureTokenStorage _tokenStorage; // ذخیره رفرنس

  // متد کمکی برای ساخت هدرها
  Future<Map<String, String>> _getHeaders({Map<String, String>? customHeaders}) async {
    final token = await _tokenStorage.readAccessToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // اگر توکن وجود داشت، به هدر اضافه کن
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    // ادغام با هدرهای سفارشی اگر وجود داشته باشد
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await _client.get(
      _buildUri(endpoint, queryParameters: queryParameters),
      headers: await _getHeaders(customHeaders: headers), // استفاده از متد جدید
    );
    return _decodeMapResponse(response);
  }

  Future<List<dynamic>> getList({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await _client.get(
      _buildUri(endpoint, queryParameters: queryParameters),
      headers: await _getHeaders(customHeaders: headers), // استفاده از متد جدید
    );
    return _decodeListResponse(response);
  }

  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final response = await _client.post(
      _buildUri(endpoint),
      headers: await _getHeaders(customHeaders: headers), // استفاده از متد جدید
      body: jsonEncode(body),
    );
    return _decodeMapResponse(response);
  }

  Future<Map<String, dynamic>> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final response = await _client.put(
      _buildUri(endpoint),
      headers: await _getHeaders(customHeaders: headers), // استفاده از متد جدید
      body: jsonEncode(body),
    );
    return _decodeMapResponse(response);
  }

  Future<Map<String, dynamic>> delete({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    final response = await _client.delete(
      _buildUri(endpoint),
      headers: await _getHeaders(customHeaders: headers), // استفاده از متد جدید
    );
    return _decodeMapResponse(response);
  }

  Uri _buildUri(String endpoint, {Map<String, dynamic>? queryParameters}) {
    final uri = Uri.parse('$_baseUrl$endpoint');
    if (queryParameters == null || queryParameters.isEmpty) return uri;
    return uri.replace(
      queryParameters: queryParameters.map(
            (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Map<String, dynamic> _decodeMapResponse(http.Response response) {
    final body = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        message: body is Map<String, dynamic> ? body['message']?.toString() ?? 'Request failed' : 'Request failed',
        statusCode: response.statusCode,
      );
    }
    return body is Map<String, dynamic> ? body : <String, dynamic>{};
  }

  List<dynamic> _decodeListResponse(http.Response response) {
    final body = response.body.isEmpty ? <dynamic>[] : jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        message: 'Request failed',
        statusCode: response.statusCode,
      );
    }
    return body is List<dynamic> ? body : <dynamic>[];
  }
}

class ApiException implements Exception {
  const ApiException({
    required this.message,
    required this.statusCode,
  });

  final String message;
  final int statusCode;

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}