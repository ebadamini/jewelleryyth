

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor{
  final SharedPreferences sharedPreferences;

  AuthInterceptor({required this.sharedPreferences});
  static const String _tokenKey = 'auth_token';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handlers) {
    // 1: Get token from local storage
    final String? token = sharedPreferences.getString(_tokenKey);

    // 2: if token exists, add it to the handler
    if(token != null && token.isNotEmpty){
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handlers);
  }
}