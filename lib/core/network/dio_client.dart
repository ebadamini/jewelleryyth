


import 'package:dio/dio.dart';
import 'package:jewelleryyth/core/constants/app_constants.dart';
import 'package:jewelleryyth/core/network/auth_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


// A wrapper class for Dio to configure network requests.

class DioClient {
  late final Dio _dio;

  DioClient({required SharedPreferences sharedPreferences}){
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
        }
      ),
    );
    
    _dio.interceptors.add(AuthInterceptor(sharedPreferences: sharedPreferences),);

    /// Adding logging interceptor for debugging (only in debug mode)
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true
      )
    );

  }
}