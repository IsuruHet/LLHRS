class UserForm {
  static Map<String, Object?> registerToJson({
    required String email,
    required String password,
    required String role,
    required String firstName,
    required String lastName,
  }) {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'uni_email': email,
      'password': password,
      'role': role
    };
  }

  static Map<String, Object?> loginToJson({
    required String id,
    required String password,
  }) {
    return {'userID': id, 'password': password};
  }
}
