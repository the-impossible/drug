class LoginResponse {
  final String? key;
  final List<dynamic>? non_field_errors;

  // constructor class
  LoginResponse({this.key, this.non_field_errors});

  factory LoginResponse.fromJson(jsonData) {
    final key = jsonData['key'];
    final non_field_errors = jsonData['non_field_errors'];

    return LoginResponse(key: key, non_field_errors: non_field_errors);
  }
}
