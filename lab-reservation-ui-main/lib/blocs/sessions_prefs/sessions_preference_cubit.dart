import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reserv/configs/sessions_details.dart';
import 'package:reserv/helpers/sessions_prefs.dart';

part 'sessions_preference_state.dart';

class SessionsPreferenceCubit extends Cubit<SessionsPreference> {
  FocusArea area;
  SessionsPreferenceCubit({required this.area})
      : super(SessionsPreference.initialState(area: area));

  void toggleForcusAreaStatus(FocusArea value) async {
    await SessionsPrefs.toggleSessionPrefStatus(value);
    emit(SessionsPreference.toggleState(area: value));
  }
}
