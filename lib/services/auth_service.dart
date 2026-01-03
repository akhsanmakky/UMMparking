import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  /// RETURN null = sukses
  /// RETURN String = error message
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } catch (e) {
      return _mapError(e);
    }
  }

  Future<String?> register({
    required String name,
    required String nim,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        uid: cred.user!.uid,
        name: name,
        nim: nim,
        email: email,
      );

      await _userService.createUserProfile(user);
      return null;
    } catch (e) {
      return _mapError(e);
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return _mapError(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // 🔐 SAFE ERROR MAPPER (WEB FRIENDLY)
  String _mapError(dynamic e) {
    if (e is FirebaseAuthException) {
      return e.message ?? 'Terjadi kesalahan autentikasi';
    }
    return 'Terjadi kesalahan. Coba lagi.';
  }
}
