import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseSeeder {
  static Future<void> seedInitialData() async {
    final db = FirebaseFirestore.instance;

    // 1. Thêm Categories
    final categories = [
      {
        'categoryId': 'CAT_COM',
        'name': 'Cơm',
        'iconUrl':
            'https://images.unsplash.com/photo-1512058564366-18510be2db19',
        'displayOrder': 1
      },
      {
        'categoryId': 'CAT_BUN',
        'name': 'Bún / Phở',
        'iconUrl':
            'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43',
        'displayOrder': 2
      },
      {
        'categoryId': 'CAT_TRASUA',
        'name': 'Trà Sữa',
        'iconUrl': 'https://images.unsplash.com/photo-1558857563-b37cf5a2c418',
        'displayOrder': 3
      },
      {
        'categoryId': 'CAT_FASTFOOD',
        'name': 'Đồ Ăn Nhanh',
        'iconUrl': 'https://images.unsplash.com/photo-1561758033-d89a9ad46330',
        'displayOrder': 4
      },
    ];
    for (var cat in categories) {
      await db
          .collection('categories')
          .doc(cat['categoryId'] as String)
          .set(cat);
    }

    // 2. Thêm Quán ăn mẫu (Khu vực Đống Đa - Hà Nội)
    await db.collection('restaurants').doc('RES_001').set({
      'restaurantId': 'RES_001',
      'ownerId': 'DEMO_MERCHANT_UID',
      'name': 'Cơm Tấm Cali - Tây Sơn',
      'phone': '0901234567',
      'address': '175 Tây Sơn, Đống Đa, Hà Nội',
      'geo': {
        'geopoint': const GeoPoint(21.0076, 105.8249),
        'geohash': 'w7eyw8z',
      },
      'imageUrl': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5',
      'rating': 4.8,
      'totalReviews': 120,
      'isOpen': true,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 3. Thêm Món ăn cho quán RES_001
    final foods = [
      {
        'foodId': 'FOOD_001',
        'restaurantId': 'RES_001',
        'categoryId': 'CAT_COM',
        'name': 'Cơm Sườn Nướng Đặc Biệt',
        'description':
            'Sườn cốt lết mật ong kèm trứng ốp la, dưa chua, mỡ hành.',
        'basePrice': 45000,
        'imageUrl': 'https://images.unsplash.com/photo-1544025162-d76694265947',
        'isAvailable': true,
        'options': {
          'sizes': [
            {'name': 'Vừa (M)', 'price': 0},
            {'name': 'Lớn (L)', 'price': 10000},
          ],
          'toppings': [
            {'name': 'Thêm trứng ốp la', 'price': 8000},
            {'name': 'Thêm chả trứng', 'price': 10000},
          ],
        },
        'rating': 4.9,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'foodId': 'FOOD_002',
        'restaurantId': 'RES_001',
        'categoryId': 'CAT_COM',
        'name': 'Cơm Gà Xối Mỡ Giòn Rụm',
        'description': 'Đùi gà góc tư chiên giòn, cơm đảo đậm đà.',
        'basePrice': 50000,
        'imageUrl':
            'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d',
        'isAvailable': true,
        'options': {
          'sizes': [
            {'name': 'Tiêu chuẩn', 'price': 0},
          ],
          'toppings': [
            {'name': 'Thêm cơm', 'price': 5000},
          ],
        },
        'rating': 4.7,
        'createdAt': FieldValue.serverTimestamp(),
      }
    ];

    for (var food in foods) {
      await db.collection('foods').doc(food['foodId'] as String).set(food);
    }

    // 4. Thêm Voucher mẫu
    await db.collection('vouchers').doc('VOUCHER_CALI10').set({
      'voucherId': 'VOUCHER_CALI10',
      'code': 'CALI10',
      'merchantId': 'RES_001',
      'title': 'Giảm 10.000đ đơn từ 50k',
      'discountType': 'fixed',
      'discountValue': 10000,
      'minOrderValue': 50000,
      'usageLimit': 100,
      'usedCount': 5,
      'isActive': true,
      'expiredAt': Timestamp.fromDate(DateTime(2027, 1, 1)),
    });
  }
}

// Widget giao diện nút bấm hỗ trợ nạp data nhanh
class SeedDataScreen extends StatefulWidget {
  const SeedDataScreen({super.key});

  @override
  State<SeedDataScreen> createState() => _SeedDataScreenState();
}

class _SeedDataScreenState extends State<SeedDataScreen> {
  bool _loading = false;
  String _message = "Bấm nút bên dưới để tạo các collection mẫu lên Firebase";

  Future<void> _handleSeed() async {
    setState(() {
      _loading = true;
      _message = "Đang tải dữ liệu lên Firestore...";
    });
    try {
      await DatabaseSeeder.seedInitialData();
      setState(() {
        _loading = false;
        _message =
            "Đã khởi tạo thành công: categories, restaurants, foods, vouchers!";
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _message = "Lỗi nạp dữ liệu: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Khởi tạo Firestore Database")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              if (_loading)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  onPressed: _handleSeed,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text("Khởi tạo Database ngay"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
