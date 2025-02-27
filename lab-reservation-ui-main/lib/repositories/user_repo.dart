import 'package:reserv/configs/apis.dart';
import 'package:reserv/models/user.dart';
import 'package:reserv/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final ApiService _apiService = ApiService.instance;

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final res = await _apiService.getVerifyRequest(kVerifyPath, token: token);
    return User.fromJson(res.data['user']);
  }

  Future<void> addUserModules() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final isAddModules = prefs.getBool("addusermodules");
    if (isAddModules == null || isAddModules == false) {
      try {
        await _apiService.postRequest(kAddModulesPath, data: {'token': token});
        await prefs.setBool("addusermodules", true);
      } catch (e) {}
    }
  }

  Future<void> removeUserModules() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool("addusermodules", false);
  }
}
