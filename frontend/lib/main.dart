import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TestFirebaseApp());
}

class TestFirebaseApp extends StatefulWidget {
  const TestFirebaseApp({super.key});

  @override
  State<TestFirebaseApp> createState() => _TestFirebaseAppState();
}

class _TestFirebaseAppState extends State<TestFirebaseApp> {
  String _statusMessage = 'Chưa kiểm tra';
  bool _isLoading = false;

  Future<void> _checkFirebaseConnection() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Đang thử kết nối tới Firebase...';
    });

    try {
      // Thử ghi một tài liệu mẫu lên bảng 'test_connection'
      final docRef = FirebaseFirestore.instance
          .collection('test_connection')
          .doc('status');

      await docRef.set({
        'connected': true,
        'message': 'Kết nối Firebase từ Flutter thành công!',
        'updated_at': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isLoading = false;
        _statusMessage =
            '✅ KẾT NỐI THÀNH CÔNG!\nDữ liệu đã được ghi lên Cloud Firestore.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = '❌ KẾT NỐI THẤT BẠI:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kiểm tra kết nối Firebase'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    onPressed: _checkFirebaseConnection,
                    icon: const Icon(Icons.cloud_sync),
                    label: const Text('Bấm để test Firebase'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                const SizedBox(height: 30),
                Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
