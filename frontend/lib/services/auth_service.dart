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
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Đăng nhập Email & Password
  Future<UserModel?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (credential.user != null) {
      return await getUserProfile(credential.user!.uid);
    }
    return null;
  }

  // Đăng ký Email & Password
  Future<UserModel?> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (credential.user != null) {
      final newUser = UserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
        roles: ['customer'],
        activeRole: 'customer',
      );

      await _firestore.collection('users').doc(newUser.uid).set({
        ...newUser.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return newUser;
    }
    return null;
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
}
