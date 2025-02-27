part of 'theme_cubit.dart';

@immutable
sealed class ThemeState {}

final class ThemeInitial extends ThemeState {
  final bool isDark;
  ThemeInitial({required this.isDark});
}

final class ThemeToggleState extends ThemeState {
  final bool isDark;
  ThemeToggleState({required this.isDark});
}
