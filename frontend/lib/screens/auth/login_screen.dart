import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Tiện ích click để điền nhanh tài khoản test
  void _fillAccount(String email) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = 'password123';
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Đăng nhập thất bại'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.delivery_dining, size: 60, color: AppColors.primary),
                const SizedBox(height: 16),
                const Text(
                  'Chào mừng bạn trở lại! 👋',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Đăng nhập để đặt món ngon hoặc quản lý cửa hàng của bạn.',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),

                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'vidu@gmail.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập email' : null,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  controller: _passwordController,
                  label: 'Mật khẩu',
                  hintText: 'Nhập mật khẩu của bạn',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
                ),
                const SizedBox(height: 28),

                CustomButton(
                  text: 'Đăng Nhập',
                  isLoading: auth.isLoading,
                  onPressed: _handleLogin,
                ),

                const SizedBox(height: 36),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  '⚡ Tài khoản mẫu chạy thử nhanh (Click để điền):',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildQuickChip('👤 Khách hàng', 'khach@gmail.com'),
                    _buildQuickChip('🏪 Chủ quán', 'chuquan@gmail.com'),
                    _buildQuickChip('🛵 Tài xế', 'taixe@gmail.com'),
                    _buildQuickChip('🛡️ Admin', 'admin@gmail.com'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label, String email) {
    return ActionChip(
      backgroundColor: AppColors.background,
      side: const BorderSide(color: AppColors.border),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: () => _fillAccount(email),
    );
  }
}
