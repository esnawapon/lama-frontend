class Credential {
  String username;
  String password;

  Credential({this.username, this.password});

  Object toObject() {
    return {
      'username': username,
      'password': password
    };
  }
}
