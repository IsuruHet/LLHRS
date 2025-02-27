import 'dart:async';

import 'package:dio/dio.dart';
import 'package:reserv/configs/apis.dart';
import 'package:reserv/helpers/sessions_prefs.dart';
import 'package:reserv/models/user_form.dart';
import 'package:reserv/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  inProgress
}

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final ApiService _apiService = ApiService.instance;

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.inProgress;
    final tokenVerified = await initLoginCredintialsVerify();
    if (tokenVerified) {
      yield AuthenticationStatus.authenticated;
    } else {
      yield AuthenticationStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  Future<bool> initLoginCredintialsVerify() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token != null) {
      try {
        await _apiService.getRequest(kVerifyPath);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  Future<void> logIn({
    required String userEmail,
    required String password,
  }) async {
    try {
      final res = await _apiService.postRequest(
        kLoginPath,
        data: UserForm.loginToJson(id: userEmail, password: password),
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", res.data['token']);
      _controller.add(AuthenticationStatus.authenticated);
    } catch (err) {
      if (err is DioException) {
        throw Exception(
            err.response?.data['message'] ?? 'Unknown error occurred');
      }
      throw Exception("An unexpected error occurred during login.");
    }
  }

  Future<void> register(
      {required String userEmail,
      required String password,
      required String firstName,
      required String lastName,
      required String role}) async {
    try {
      final data = UserForm.registerToJson(
          email: userEmail,
          password: password,
          firstName: firstName,
          lastName: lastName,
          role: role);
      await _apiService.postRequest(kRegisterPath, data: data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Unknown error occurred");
    }
  }

  Future<void> logOut() async {
    _controller.add(AuthenticationStatus.unauthenticated);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", "");
    await SessionsPrefs.resetSessionPrefStatus();
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _apiService.postRequest(
        kforgotPasswordPath,
        data: {"uni_email": email},
      );
    } catch (err) {
      if (err is DioException) {
        throw Exception(
            err.response?.data['message'] ?? 'Unknown error occurred');
      }
      throw Exception("An unexpected error occurred during login.");
    }
  }

  void dispose() => _controller.close();
}
