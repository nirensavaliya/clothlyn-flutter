import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_core/src/get_main.dart';

import '../Common/Get_storage_data.dart';
import '../Utills/App_Routes.dart';
import 'Api_Constants.dart';

class ApiService {
  late Dio _dio;
  /*final token = GetStorageData.readString(GetStorageData.token);
  final userType = GetStorageData.readString(GetStorageData.userType);
  final isLoggedIn = GetStorageData.readString(GetStorageData.isOtpVerified);*/

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            print("⚠️ Token expired → Auto logout");

            await GetStorageData.removeData(GetStorageData.token);
            await GetStorageData.removeData(GetStorageData.userType);
            await GetStorageData.removeData(GetStorageData.isOtpVerified);

            Get.offAllNamed(AppRoutes.loginScreen);
          }

          return handler.next(error);
        },
      ),
    );
  }

  /// Safe message from Dio error (HTML string must not use map index)
  String _dioErrorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map) {
      final message = data['message'];
      if (message != null && message.toString().isNotEmpty) {
        return message.toString();
      }
    }
    if (data is String && data.trim().isNotEmpty) {
      final preMatch =
          RegExp(r'<pre>(.*?)</pre>', dotAll: true).firstMatch(data);
      if (preMatch != null) {
        return preMatch.group(1)?.trim() ?? fallback;
      }
      if (data.length < 200 && !data.trimLeft().startsWith('<')) {
        return data;
      }
    }
    return e.message ?? fallback;
  }

  /// Reusable GET Method
  Future<Response> getRequest(String endpoint,
      {Map<String, dynamic>? queryParams, Map<String, dynamic>? headers, ResponseType? responseType}) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(headers: headers,responseType: responseType),
      );
      return response;
    } on DioException catch (e) {
      throw Exception(_dioErrorMessage(e, "API Error"));
    }
  }

  /// Generic POST
  Future<Response> postRequest(
      String endpoint, {
        // Map<String, dynamic>? data,
        dynamic data,
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
        ),
      );
      print('POST--API---${response}');
      return response;
    } on DioException catch (e) {
      throw Exception(_dioErrorMessage(e, "POST API Error"));
    }
  }

  Future<Response> putRequest(String url,
      {dynamic data,
        Map<String, String>? headers}) async {
    return await _dio.put(
      url,
      data: data,
      options: Options(headers: headers),
    );
  }

  Future<Response> deleteRequest(String url,
      {Map<String, dynamic>? data,
        Map<String, String>? headers}) async {
    print("---- DELETE API CALLED ----");
    print("Base URL: ${url}");
    print("Full URL: ${_dio.options.baseUrl}$url");
    print("Headers: $headers");
    print("Body: $data");
    return await _dio.delete(
      url,
      data: data,
      options: Options(headers: headers),
    );

  }

  /// Generic PATCH
  Future<Response> patchRequest(
      String url, {
        Map<String, dynamic>? data,
        Map<String, String>? headers,
      }) async {
    try {
      final response = await _dio.patch(
        url,
        data: data,
        options: Options(headers: headers),
      );

      print("PATCH API RESPONSE: $response");

      return response;
    } on DioException catch (e) {
      throw Exception(_dioErrorMessage(e, "PATCH API Error"));
    }
  }

}