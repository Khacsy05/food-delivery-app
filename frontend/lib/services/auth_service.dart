import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream theo dõi trạng thái auth
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // Lấy thông tin user từ Firestore theo UID
  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return UserModel.fromMap(
      doc.data()!,
      doc.id,
    );
  }

  // Đăng nhập Email & Password
  Future<UserModel?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (credential.user == null) {
      return null;
    }

    return getUserProfile(
      credential.user!.uid,
    );
  }

  // Đăng ký Email & Password
  Future<UserModel?> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) {
        return null;
      }

      final newUser = UserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        avatarUrl:
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
        roles: ['customer'],
        activeRole: 'customer',
        defaultAddress: null,
      );

      await _firestore.collection('users').doc(newUser.uid).set({
        ...newUser.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // createUserWithEmailAndPassword signs in automatically. Sign out so a
      // successful registration returns the user to the login flow.
      await _auth.signOut();

      return newUser;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // reset mật khẩu
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // Chuyển vai trò hoạt động (activeRole) cho user đa vai trò
  Future<void> switchRole(String uid, String newRole) async {
    await _firestore.collection('users').doc(uid).update({
      'activeRole': newRole,
    });
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //FIREBASE ERROR → USER MESSAGE
  String getErrorMessage(Object error) {
    if (error is! FirebaseAuthException) {
      return 'Đã xảy ra lỗi. Vui lòng thử lại.';
    }

    switch (error.code) {
      case 'invalid-email':
        return 'Email không hợp lệ.';

      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Email hoặc mật khẩu không chính xác.';

      case 'email-already-in-use':
        return 'Email này đã được sử dụng.';

      case 'weak-password':
        return 'Mật khẩu quá yếu.';

      case 'user-disabled':
        return 'Tài khoản đã bị khóa.';

      case 'too-many-requests':
        return 'Bạn thử quá nhiều lần. Vui lòng thử lại sau.';

      case 'network-request-failed':
        return 'Không thể kết nối mạng.';

      default:
        return 'Đã xảy ra lỗi xác thực. Vui lòng thử lại.';
    }
  }
}
