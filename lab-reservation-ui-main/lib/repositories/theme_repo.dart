import 'package:reserv/helpers/theme_helper.dart';

class ThemeRepository {
  ThemeRepository({required this.initThemeStatus});
  final bool initThemeStatus;
  Future<void> toggleThemePreferece(bool val) async {
    await ThemeHelper.toggleThemePreferece(val);
  }

  bool getinitialThemePreferece() {
    return initThemeStatus;
  }
}
