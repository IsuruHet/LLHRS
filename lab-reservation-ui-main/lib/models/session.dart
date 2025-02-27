import 'package:equatable/equatable.dart';

class Session extends Equatable {
  const Session({
    required this.moduleCode,
    required this.moduleName,
    required this.moduleType,
    required this.hlName,
    required this.resource,
    required this.semester,
    required this.academicYear,
    required this.ldUniEmail,
    required this.startTime,
    required this.endTime,
    required this.day,
    required this.date,
  });

  final String moduleCode;
  final String moduleName;
  final String moduleType;
  final String hlName;
  final int resource;
  final String semester;
  final String academicYear;
  final String ldUniEmail;
  final String startTime;
  final String endTime;
  final String day;
  final String date;

  @override
  List<Object> get props => [
        moduleCode,
        moduleName,
        moduleType,
        hlName,
        resource,
        semester,
        academicYear,
        ldUniEmail,
        startTime,
        endTime,
        day,
      ];

  static const empty = Session(
    moduleCode: '',
    moduleName: '',
    moduleType: '',
    hlName: '',
    resource: 0,
    semester: "",
    academicYear: '',
    ldUniEmail: '',
    startTime: '',
    endTime: '',
    day: '',
    date: '',
  );

  factory Session.fromJson(Map<String, Object?> json) {
    return Session(
      moduleCode: json['module_code'] as String? ?? '',
      moduleName: json['module_name'] as String? ?? '',
      moduleType: json['module_type'] as String? ?? '',
      hlName: json['hl_name'] as String? ?? '',
      resource: json['capacity'] as int? ?? 0,
      semester: json['semester'] as String? ?? "N/A",
      academicYear: json['academic_year'] as String? ?? '',
      ldUniEmail: json['l_d_uni_email'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      day: json['day'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );
  }
}
