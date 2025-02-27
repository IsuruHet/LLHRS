import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  ApiService._internal();
  static final _instance = ApiService._internal();
  static ApiService get instance => _instance;
  late Dio _dio;
  void configurationDio({
    required String baseUrl,
    String? token,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
    ));
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<Response> getRequest(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getVerifyRequest(String endpoint, {String? token}) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      Response response = await _dio.get(
        endpoint,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postRequest(String endpoint,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token != null) {
      return token;
    }
    return "";
  }
}
