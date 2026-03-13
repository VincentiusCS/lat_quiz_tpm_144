/// Model User - menerapkan Encapsulation
/// Field username dan password dibuat private,
/// hanya bisa diakses via getter dan method isValid()
class User {
  final String _username;
  final String _password;

  const User({
    required String username,
    required String password,
  })  : _username = username,
        _password = password;

  /// Getter untuk username (read-only)
  String get username => _username;

  /// Validasi kredensial tanpa mengekspos password keluar
  bool isValid(String username, String password) {
    return _username == username && _password == password;
  }

  @override
  String toString() => 'User(username: $_username)';
}
