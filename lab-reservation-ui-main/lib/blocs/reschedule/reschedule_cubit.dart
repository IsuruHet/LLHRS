import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:reserv/models/available_slot.dart';
import 'package:reserv/models/session.dart';
import 'package:reserv/repositories/rechedule_repo.dart';

part 'reschedule_state.dart';

class RescheduleCubit extends Cubit<RescheduleState> {
  final RecheduleRepository recheduleRepository;
  RescheduleCubit(this.recheduleRepository)
      : super(const RescheduleState.initial());

  Future<void> getAvailableSlots(
      {required DateTime date,
      required TimeOfDay startTime,
      required TimeOfDay endTime,
      required int capacity,
      required String moduleType}) async {
    emit(const RescheduleState.searching());
    try {
      final slots = await recheduleRepository.getAvailableSlots(
        date: date,
        startTime: startTime,
        endTime: endTime,
        capacity: capacity,
        moduleType: moduleType,
      );
      emit(RescheduleState.searched(availableSlots: slots));
    } catch (e) {
      emit(const RescheduleState.initial());
    }
  }

  Future<bool> rescheduleModule({
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required int capacity,
    required Session session,
    required String hlName,
  }) async {
    try {
      await recheduleRepository.rescheduleModule(
          date: date,
          startTime: startTime,
          endTime: endTime,
          capacity: capacity,
          session: session,
          hlName: hlName);
      return true;
    } catch (e) {
      print("Failed to get available slots: $e");
      return false;
    }
  }

  void reset() {
    emit(const RescheduleState.initial());
  }
}
