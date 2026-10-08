import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/auth_mode_switch.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final auth = context.read<AuthProvider>();

    final success = await auth.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => route.isFirst,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công. Vui lòng đăng nhập.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ??
                'Đăng ký thất bại. Vui lòng thử lại.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  String? _required(
    String? value,
    String message,
  ) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding =
                constraints.maxWidth < 360
                    ? 10.0
                    : 20.0;

            return SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),

              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 420,
                  ),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      children: [
                        const AuthHeader(
                          title: 'TẠO TÀI KHOẢN MỚI!',
                        ),

                        const SizedBox(height: 14),

                        AuthModeSwitch(
                          isLogin: false,
                          onLogin: _goToLogin,
                          onRegister: () {},
                        ),

                        const SizedBox(height: 12),

                        CustomTextField(
                          controller:
                              _nameController,
                          label: 'Họ và tên',
                          hintText:
                              'Lê Minh Hương',
                          prefixIcon:
                              Icons.person_outline,
                          labelFontSize: 9,
                          fieldHeight: 40,
                          borderRadius: 9,
                          validator: (value) =>
                              _required(
                            value,
                            'Vui lòng nhập họ và tên',
                          ),
                        ),

                        const SizedBox(height: 8),

                        CustomTextField(
                          controller:
                              _phoneController,
                          label: 'Số điện thoại',
                          hintText:
                              '0908 123 456',
                          prefixIcon:
                              Icons.phone_outlined,
                          keyboardType:
                              TextInputType.phone,
                          labelFontSize: 9,
                          fieldHeight: 40,
                          borderRadius: 9,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Vui lòng nhập số điện thoại';
                            }

                            if (value.trim().length <
                                9) {
                              return 'Số điện thoại không hợp lệ';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 8),

                        CustomTextField(
                          controller:
                              _emailController,
                          label: 'Email',
                          hintText:
                              'gourmet.lover@saigon.vn',
                          prefixIcon:
                              Icons.email_outlined,
                          keyboardType:
                              TextInputType.emailAddress,
                          labelFontSize: 9,
                          fieldHeight: 40,
                          borderRadius: 9,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Vui lòng nhập email';
                            }

                            final emailRegex =
                                RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            );

                            if (!emailRegex
                                .hasMatch(
                              value.trim(),
                            )) {
                              return 'Email không hợp lệ';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 8),

                        CustomTextField(
                          controller:
                              _passwordController,
                          label: 'Mật khẩu',
                          hintText:
                              'Tối thiểu 8 ký tự',
                          prefixIcon:
                              Icons.lock_outline,
                          obscureText:
                              _obscurePassword,
                          labelFontSize: 9,
                          fieldHeight: 40,
                          borderRadius: 9,
                          suffixIcon:
                              IconButton(
                            padding:
                                EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                _obscurePassword =
                                    !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons
                                      .visibility_outlined
                                  : Icons
                                      .visibility_off_outlined,
                              size: 16,
                              color:
                                  const Color(
                                0xFF718096,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            }

                            if (value.length < 8) {
                              return 'Mật khẩu phải có ít nhất 8 ký tự';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 13),

                        CustomButton(
                          text: 'ĐĂNG KÝ NGAY  →',
                          onPressed: _register,
                          isLoading:
                              auth.isLoading,
                          height: 40,
                          borderRadius: 8,
                          fontSize: 10,
                        ),

                        const SizedBox(height: 13),

                        _buildDivider(),

                        const SizedBox(height: 8),

                        _buildSocialButtons(),

                        const SizedBox(height: 11),

                        // TODO:
                        // Component AuthQuickRoles
                        // sẽ dùng chung Login/Register.

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Đã có tài khoản? ',
                              style: TextStyle(
                                fontSize: 9,
                                color:
                                    Color(0xFF687386),
                              ),
                            ),
                            GestureDetector(
                              onTap: _goToLogin,
                              child: const Text(
                                'Đăng nhập ngay',
                                style: TextStyle(
                                  fontSize: 9,
                                  color:
                                      AppColors.primary,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(0xFFE3E7ED),
          ),
        ),
        const Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 9),
          child: Text(
            'Hoặc đăng ký với',
            style: TextStyle(
              fontSize: 8,
              color: Color(0xFF7A8494),
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(0xFFE3E7ED),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        _social('G'),
        const SizedBox(width: 8),
        _social(
          '●',
          color: Colors.black,
        ),
        const SizedBox(width: 8),
        _social(
          'f',
          color: const Color(0xFF1877F2),
        ),
      ],
    );
  }

  Widget _social(
    String text, {
    Color? color,
  }) {
    return Expanded(
      child: SizedBox(
        height: 37,
        child: OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'Đăng ký bằng mạng xã hội chưa được cấu hình.',
                ),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(
              color: Color(0xFFE1E6EC),
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color ??
                  const Color(0xFF4285F4),
            ),
          ),
        ),
      ),
    );
  }
}
