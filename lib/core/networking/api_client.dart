// ignore_for_file: unused_import, unused_field

import 'package:dio/dio.dart';
import 'token_service.dart';

class ApiClient {
  static final Dio dio = _initDio();

  static Dio _initDio() {
    final Dio dioInstance = Dio(
      BaseOptions(
        baseUrl: "http://192.168.1.101:8000",
        //baseUrl: "http://localhost:8000",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dioInstance.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path.contains('signin') ||
              options.path.contains('signup')) {
            options.headers.remove('Authorization');
            return handler.next(options);
          }
          final token = await TokenService().getAccessToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );

    dioInstance.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
    return dioInstance;
  }
}
