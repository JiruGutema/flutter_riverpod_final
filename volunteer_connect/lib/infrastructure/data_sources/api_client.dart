
import 'package:dio/dio.dart';
import 'dart:convert'; // only if you need jsonEncode elsewhere
import '../storage/secure_storage.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:5500/api",
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<void> _attachToken() async {
    final token = await SecureStorage.getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  static Future<Response> post(
    String path,
    dynamic data, {
    bool requiresAuth = false,
    Map<String, String>? headers,
  }) async {
    if (requiresAuth) await _attachToken();
    if (headers != null) {
      _dio.options.headers.addAll(headers);
    }
    return _dio.post(path, data: data);
  }

  static Future<Response> patch(
    String path, {
    dynamic data,
    bool requiresAuth = false,
    Map<String, String>? headers,
  }) async {
    if (requiresAuth) await _attachToken();
    if (headers != null) {
      _dio.options.headers.addAll(headers);
    }
    return _dio.patch(path, data: data);
  }

  static Future<Response> get(
    String path, {
    bool requiresAuth = false,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (requiresAuth) await _attachToken();
    if (headers != null) {
      _dio.options.headers.addAll(headers);
    }
    return _dio.get(path, queryParameters: queryParameters);
  }

  static Future<Response> put(
    String path,
    dynamic data, {
    bool requiresAuth = false,
    Map<String, String>? headers,
  }) async {
    if (requiresAuth) await _attachToken();
    if (headers != null) {
      _dio.options.headers.addAll(headers);
    }
    return _dio.put(path, data: data);
  }

  static Future<Response> delete(
    String path, {
    bool requiresAuth = false,
    Map<String, String>? headers,
  }) async {
    if (requiresAuth) await _attachToken();
    if (headers != null) {
      _dio.options.headers.addAll(headers);
    }
    return _dio.delete(path);
  }
}
