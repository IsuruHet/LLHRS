import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.academicYear,
      required this.degree,
      required this.role,
      required this.email});

  final String id;
  final String firstName;
  final String lastName;
  final String academicYear;
  final String degree;
  final String email;
  final String role;

  @override
  List<Object> get props => [id, firstName, lastName];

  static const empty = User(
      id: '-',
      firstName: "",
      lastName: "",
      academicYear: "",
      degree: "",
      email: "",
      role: "");

  factory User.fromJson(Map<String, Object?> json) {
    return User(
      id: json['id'] as String? ?? "N/A",
      email: json['email'] as String? ?? "N/A",
      academicYear: json['academicYear'] as String? ?? "N/A",
      degree: json['degree'] as String? ?? "N/A",
      firstName: json['firstName'] as String? ?? "N/A",
      lastName: json['lastName'] as String? ?? "N/A",
      role: json['role'] as String? ?? "N/A",
    );
  }
}
