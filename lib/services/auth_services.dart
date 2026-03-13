import '../models/user.dart';

/// Service autentikasi menggunakan Singleton Pattern
/// Hanya ada satu instance AuthService di seluruh aplikasi
class AuthService {
  // ── Singleton ──────────────────────────────────
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  // ───────────────────────────────────────────────

  /// Simulasi database pengguna
  final List<User> _users = const [
    User(username: 'Alfin', password: 'Alfin123'),
    User(username: 'vincent', password: '144'),
  ];

  User? _currentUser;

  // Getters (Encapsulation)
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Login: mencari user yang cocok dan menyimpan sesi
  bool login(String username, String password) {
    for (final user in _users) {
      if (user.isValid(username, password)) {
        _currentUser = user;
        return true;
      }
    }
    return false;
  }

  /// Logout: menghapus sesi
  void logout() {
    _currentUser = null;
  }
}
