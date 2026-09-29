import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';
import '../customer/customer_home_screen.dart';
import '../merchant/merchant_dashboard_screen.dart';
import '../shipper/shipper_dashboard_screen.dart';
import '../admin/admin_dashboard_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Nếu chưa đăng nhập -> Hiển thị LoginScreen
    if (!auth.isAuthenticated || auth.user == null) {
      return const LoginScreen();
    }

    final activeRole = auth.user!.activeRole;

    // Điều hướng theo đúng Role đã cấu hình
    switch (activeRole) {
      case 'merchant':
        return const MerchantDashboardScreen();
      case 'shipper':
        return const ShipperDashboardScreen();
      case 'admin':
        return const AdminDashboardScreen();
      case 'customer':
      default:
        return const CustomerHomeScreen();
    }
  }
}
