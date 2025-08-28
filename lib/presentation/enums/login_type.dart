enum LoginType {
  email("email"),
  phoneNumber("phoneNumber");

  const LoginType(this.type);
  final String type;

  static LoginType? fromValue({required String value}) {
    LoginType? result;
    LoginType.values.forEach((LoginType type) {
      if (type.type == value) {
        result = type;
      }
    });
    return result;
  }
}
