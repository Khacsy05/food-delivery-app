import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  // Khởi tạo và lắng nghe thay đổi trạng thái user
  void _init() {
    _authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        _user = await _authService.getUserProfile(firebaseUser.uid);
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  // Đăng nhập
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _user = await _authService.signInWithEmail(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Đăng ký
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _user = await _authService.registerWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Đổi vai trò hoạt động
  Future<void> switchRole(String newRole) async {
    if (_user == null) return;
    try {
      await _authService.switchRole(_user!.uid, newRole);
      _user = await _authService.getUserProfile(_user!.uid);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
