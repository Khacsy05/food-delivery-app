import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/app_colors.dart';

class MerchantDashboardScreen extends StatelessWidget {
  const MerchantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kênh Quán Ăn 🏪', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.storefront, size: 70, color: AppColors.accent),
              const SizedBox(height: 16),
              Text(
                'Quán của: ${user?.name}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Mã Quán: ${user?.restaurantId ?? "Chưa liên kết"}',
                style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              const Text(
                'Màn hình Quán ăn: Quản lý món, nhận & xử lý đơn hàng.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
