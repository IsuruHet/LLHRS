part of 'reschedule_cubit.dart';

enum RescheduleStatus { initial, searched, searching, empty }

class RescheduleState extends Equatable {
  const RescheduleState._({
    this.availableSlots = const <AvailableSlot>[],
    this.status = RescheduleStatus.initial,
  });

  const RescheduleState.initial() : this._();

  RescheduleState.searched({
    required List<AvailableSlot> availableSlots,
  }) : this._(
            availableSlots: availableSlots,
            status: availableSlots.isEmpty
                ? RescheduleStatus.empty
                : RescheduleStatus.searched);

  const RescheduleState.searching()
      : this._(status: RescheduleStatus.searching);

  const RescheduleState.empty() : this._(status: RescheduleStatus.empty);

  final List<AvailableSlot> availableSlots;
  final RescheduleStatus status;

  @override
  List<Object?> get props => [availableSlots, status];
}
