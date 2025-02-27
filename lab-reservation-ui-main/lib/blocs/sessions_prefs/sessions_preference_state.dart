part of 'sessions_preference_cubit.dart';

final class SessionsPreference extends Equatable {
  final FocusArea area;

  const SessionsPreference.initialState({required this.area});
  const SessionsPreference.toggleState({required this.area});
  @override
  List<Object> get props => [area];
}
