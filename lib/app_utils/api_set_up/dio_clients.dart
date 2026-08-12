import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';

void logPrintFull(Object? object) {
  final str = object.toString();
  log(str);
  const int chunkSize = 1000;
  for (int i = 0; i < str.length; i += chunkSize) {
    debugPrint(str.substring(i, i + chunkSize > str.length ? str.length : i + chunkSize));
  }
}

String _formatBody(dynamic data) {
  if (data == null) return "null";
  if (data is FormData) {
    final Map<String, dynamic> fields = {};
    for (var element in data.fields) {
      fields[element.key] = element.value;
    }
    final List<String> files = data.files.map((e) => "${e.key}: ${e.value.filename}").toList();
    return "FormData(fields: $fields, files: $files)";
  }
  return data.toString();
}

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = baseURL
      ..options.connectTimeout = const Duration(seconds: 25)
      ..options.receiveTimeout = const Duration(seconds: 25)
      ..options.responseType = ResponseType.json
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            logPrintFull("==================== API REQUEST ====================");
            logPrintFull("--> ${options.method.toUpperCase()} ${options.uri}");
            logPrintFull("Headers: ${options.headers}");
            final mergedQueryParams = {
              ...options.uri.queryParameters,
              ...options.queryParameters,
            };
            logPrintFull("Query Parameters: ${mergedQueryParams.isNotEmpty ? mergedQueryParams : 'None'}");
            logPrintFull("Request Body/Data: ${_formatBody(options.data)}");
            logPrintFull("=====================================================");
            return handler.next(options);
          },
          onResponse: (response, handler) {
            logPrintFull("==================== API RESPONSE ====================");
            logPrintFull("<-- [${response.statusCode}] ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}");
            logPrintFull("Response Body: ${response.data}");
            logPrintFull("======================================================");
            return handler.next(response);
          },
          onError: (DioException err, handler) {
            logPrintFull("==================== API ERROR ====================");
            logPrintFull("<-- ERROR [${err.response?.statusCode}] ${err.requestOptions.method.toUpperCase()} ${err.requestOptions.uri}");
            logPrintFull("Error Message: ${err.message}");
            if (err.response != null) {
              logPrintFull("Error Response: ${err.response?.data}");
            }
            logPrintFull("===================================================");
            return handler.next(err);
          },
        ),
      );
  }

  // Get:-----------------------------------------------------------------------
  Future<Response> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<Response> post(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<Response> put(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
