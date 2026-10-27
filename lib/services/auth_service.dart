import '../database/database_helper.dart';
import '../models/user.dart';

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<bool> register(String username, String email, String password) async {
    try {
      User newUser = User(
        username: username,
        email: email,
        password: password,
      );
      await _dbHelper.insertUser(newUser.toMap());
      return true;
    } catch (e) {
      print('Error al registrar: $e');
      return false;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      Map<String, dynamic>? userData = await _dbHelper.validateUser(email, password);
      if (userData != null) {
        return User.fromMap(userData);
      }
      return null;
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null;
    }
  }
}