import 'package:equatable/equatable.dart';

class Reschadule extends Equatable {
  const Reschadule({
    required this.id,
    required this.hlName,
    // required this.reschedule,
  });

  final String id;
  final String hlName;
  // final bool reschedule;

  @override
  List<Object> get props => [
        id, hlName,
        //reschedule
      ];

  static const empty = Reschadule(
    id: '-',
    hlName: "",
    // reschedule: false,
  );

  factory Reschadule.fromJson(Map<String, Object?> json) {
    return Reschadule(
      id: json['_id'] as String? ?? "N/A",
      hlName: json['hl_name'] as String? ?? "N/A",
      // reschedule: json['reschedule'] as bool? ?? false,
    );
  }
}
