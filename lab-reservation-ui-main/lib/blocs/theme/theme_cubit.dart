import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reserv/repositories/theme_repo.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeRepository themeRepository;
  ThemeCubit({required this.themeRepository})
      : super(ThemeInitial(isDark: themeRepository.getinitialThemePreferece()));

  void toggleTheme(bool val) async {
    emit(ThemeToggleState(isDark: val));
    await themeRepository.toggleThemePreferece(val);
  }
}
