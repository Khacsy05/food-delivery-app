import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;

  bool _isLoading = false;
  bool _isInitialized = false;

  String? _errorMessage;

  StreamSubscription<User?>? _authSubscription;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  // Khởi tạo và lắng nghe thay đổi trạng thái user
  void _init() {
    _authSubscription =
        _authService.authStateChanges.listen((User? firebaseUser) async {
      try {
        if (firebaseUser != null) {
          final profile = await _authService.getUserProfile(firebaseUser.uid);
          // Ignore a profile lookup that finishes after this account signed out
          // or another account became active.
          if (_authService.currentUser?.uid == firebaseUser.uid) {
            _user = profile;
          }
        } else {
          _user = null;
        }
      } catch (e) {
        _user = null;
        _errorMessage = _authService.getErrorMessage(e);
      } finally {
        _isInitialized = true;
        notifyListeners();
      }
    });
  }

  // Đăng nhập
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await _authService.signInWithEmail(email, password);
      return _user != null;
    } catch (e) {
      _errorMessage = _authService.getErrorMessage(e);

      return false;
    } finally {
      _setLoading(false);
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
      await _authService.registerWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      // Firebase signs a newly created account in automatically. Registration
      // should finish at the login screen, so do not expose it as authenticated.
      _user = null;
      return true;
    } catch (e) {
      _errorMessage = _authService.getErrorMessage(e);

      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Lấy lại mật khẩu
  Future<bool> resetPassword(
    String email,
  ) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.resetPassword(email);

      return true;
    } catch (e) {
      _errorMessage = _authService.getErrorMessage(e);

      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Đổi vai trò hoạt động
  Future<bool> switchRole(String newRole) async {
    if (_user == null) {
      _errorMessage = 'Vui lòng đăng nhập để đổi vai trò.';
      notifyListeners();
      return false;
    }

    if (!_user!.roles.contains(newRole)) {
      _errorMessage = 'Bạn không có quyền truy cập vai trò này.';
      notifyListeners();
      return false;
    }

    if (_user!.activeRole == newRole) {
      return true;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.switchRole(_user!.uid, newRole);
      _user = _user!.copyWith(activeRole: newRole);
      return true;
    } catch (e) {
      _errorMessage = _authService.getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.signOut();
      _user = null;
    } catch (e) {
      _errorMessage = _authService.getErrorMessage(e);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
