import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  String? _accessToken;

  String? get accessToken => _accessToken;

  void setAccessToken(String? accessToken) {
    _accessToken = accessToken;
  }

  void clearAccessToken() {
    _accessToken = null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = _accessToken;

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }
}
