import 'package:dio/dio.dart';

import 'rest_transport.dart';

final class DioRestTransport implements RestTransport {
  final Dio _dio;

  const DioRestTransport({required Dio dio}) : _dio = dio;

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
    );

    return response.data;
  }

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _buildOptions(headers),
    );

    return response.data;
  }

  @override
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.patch<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _buildOptions(headers),
    );

    return response.data;
  }

  Options? _buildOptions(Map<String, dynamic>? headers) {
    if (headers == null || headers.isEmpty) {
      return null;
    }

    return Options(headers: headers);
  }
}
