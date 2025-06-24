import 'package:dio/dio.dart';
import 'package:pro/widget/token.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenManager.getToken();
    options.headers['Accept-Language'] = 'en';
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}

// import 'package:dio/dio.dart';

// class ApiInterceptor extends Interceptor {
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     options.headers['Accept-Language'] = "en";
//     super.onRequest(options, handler);
//   }
// }
