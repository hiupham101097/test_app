import 'dart:convert';

import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/utils/object_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BaseClient {
  static const _apiHostOrder = 'https://devorder.chothongminh.com';
  static const _apiHostWallet = 'https://dev-wallet.bigcode.vn';
  static const _apiHostSso = 'https://devsso.chothongminh.com';
  static const _apiHostPartner = 'https://devpartner.chothongminh.com';
  static const _apiHostContent = 'https://devcontent.chothongminh.com';
  // static const _apiHostOrder = 'https://order-api.chothongminh.com';
  // static const _apiHostWallet = 'https://wallet-api.gober.vn';
  // static const _apiHostSso = 'https://sso-api.chothongminh.com';
  // static const _apiHostPartner = 'https://partner-api.chothongminh.com';
  // static const _apiHostContent = 'https://content-api.chothongminh.com';
  static BaseClient? _instance;
  Dio? _dio;

  BaseClient();

  static get instance {
    _instance ??= BaseClient._internal();
    return _instance;
  }

  get apiHostOrder => _apiHostOrder;
  get apiHostWallet => _apiHostWallet;
  get apiHostSso => _apiHostSso;
  get apiHostPartner => _apiHostPartner;
  get apiHostContent => _apiHostContent;
  get dio => _dio;

  BaseClient._internal() {
    _dio = Dio();
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['accept'] = 'application/json';

          if (kDebugMode) {
            print(
              'Call api: ${options.method} ${options.path} ${options.data}',
            );
          }
          final token = sl<LocalClient>().accessToken;
          if (ObjectUtil.isNotEmpty(token)) {
            options.headers['Authorization'] = 'Bearer $token';
            print(token);
          }
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.data is String) {
            try {
              response.data = jsonDecode(response.data as String);
            } catch (e) {
              if (kDebugMode) print('Failed to parse JSON: $e');
            }
          }

          if (kDebugMode) {
            print(
              'API STATUS CODE ${response.statusCode} ${response.statusMessage}',
            );
            print("Response ${response.data}");
          }

          if (response.data is Map<String, dynamic> &&
              response.data['status'] == 0) {
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
                error: response.data['message'],
              ),
            );
          }

          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extraHeaders,
  }) {
    final options = Options(headers: extraHeaders);
    return _dio!.get(path, options: options);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? extraHeaders,
  }) {
    final options = Options(headers: extraHeaders);
    return _dio!.put(path, data: data, options: options);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? extraHeaders,
  }) {
    final options = Options(headers: extraHeaders);
    return _dio!.post(path, data: data, options: options);
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? extraHeaders,
    dynamic data,
  }) {
    final options = Options(headers: extraHeaders);
    return _dio!.delete(path, options: options, data: data);
  }
}
