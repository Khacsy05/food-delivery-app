import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // =========================================================
  // DEMO ACCOUNT
  // =========================================================

  void _fillAccount(String email) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = 'password123';
    });
  }

  // =========================================================
  // LOGIN
  // =========================================================

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final auth = context.read<AuthProvider>();

    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ?? 'Đăng nhập thất bại',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // =========================================================
  // QUICK ROLE CARD
  // =========================================================

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required String email,
    required IconData icon,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _fillAccount(email),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 58,
          ),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFE1E6EC),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F8F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 8,
                        color: Color(0xFF7A8494),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // OLD DEMO BUTTON
  // Giữ lại để không mất chức năng hiện tại.
  // =========================================================

  Widget _buildOldDemoChip(
    String label,
    String email,
  ) {
    return ActionChip(
      backgroundColor: Colors.white,
      side: const BorderSide(
        color: Color(0xFFE1E6EC),
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF455064),
        ),
      ),
      onPressed: () => _fillAccount(email),
    );
  }

  // =========================================================
  // SOCIAL BUTTON
  // =========================================================

  Widget _buildSocialButton({
    required Widget icon,
    required String label,
  }) {
    return Expanded(
      child: SizedBox(
        height: 38,
        child: OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '$label chưa được cấu hình.',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(
              color: Color(0xFFE1E6EC),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
            padding: EdgeInsets.zero,
          ),
          child: icon,
        ),
      ),
    );
  }

  // =========================================================
  // INPUT FIELD
  // =========================================================

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172033),
          ),
        ),

        const SizedBox(height: 6),

        SizedBox(
          height: 42,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF263142),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9AA3B0),
              ),
              prefixIcon: Icon(
                prefixIcon,
                size: 17,
                color: AppColors.primary,
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: Color(0xFFE1E6EC),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: Color(0xFFE1E6EC),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            // Responsive horizontal padding.
            final horizontalPadding =
                width < 390 ? 20.0 : 24.0;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 18,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 420,
                  ),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,

                      children: [
                        // =================================================
                        // LOGO
                        // =================================================

                        const SizedBox(height: 4),

                        Center(
                          child: Container(
                            width: 54,
                            height: 54,
                            padding: const EdgeInsets.all(6),

                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F7F7),
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),

                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),

                              child: const Icon(
                                Icons.restaurant,
                                color: Colors.white,
                                size: 27,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 13),

                        // =================================================
                        // TITLE
                        // =================================================

                        const Text(
                          'CHÀO MỪNG TRỞ LẠI!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                            color: Color(0xFF111827),
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 25),

                          child: Text(
                            'Khám phá thế giới ẩm thực hấp dẫn ngay\nhôm nay',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.45,
                              color: Color(0xFF687386),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // =================================================
                        // LOGIN / REGISTER TAB
                        // =================================================

                        Container(
                          height: 35,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(9),
                            border: Border.all(
                              color: const Color(0xFFE1E6EC),
                            ),
                          ),

                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin:
                                      const EdgeInsets.all(3),

                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius:
                                        BorderRadius.circular(7),
                                  ),

                                  child: const Center(
                                    child: Text(
                                      'Đăng Nhập',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    // TODO:
                                    // Điều hướng RegisterScreen
                                  },

                                  child: const Center(
                                    child: Text(
                                      'Đăng Ký',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF4B5563),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 13),

                        // =================================================
                        // EMAIL
                        // =================================================

                        _buildInputField(
                          label: 'Email hoặc Số điện thoại',
                          hintText: 'gourmet.lover@saigon.vn',
                          controller: _emailController,
                          prefixIcon:
                              Icons.mail_outline,
                          keyboardType:
                              TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Vui lòng nhập email';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 10),

                        // =================================================
                        // PASSWORD
                        // =================================================

                        _buildInputField(
                          label: 'Mật khẩu',
                          hintText: 'Nhập mật khẩu',
                          controller: _passwordController,
                          prefixIcon:
                              Icons.lock_outline,
                          obscureText:
                              _obscurePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword =
                                    !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 17,
                              color:
                                  const Color(0xFF536174),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            }

                            return null;
                          },
                        ),

                        // =================================================
                        // FORGOT PASSWORD
                        // =================================================

                        Align(
                          alignment:
                              Alignment.centerRight,

                          child: TextButton(
                            onPressed: () {
                              // TODO:
                              // Mở Forgot Password Screen
                            },

                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(
                                top: 1,
                                bottom: 1,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),

                            child: const Text(
                              'Quên mật khẩu?',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // =================================================
                        // LOGIN BUTTON
                        // =================================================

                        SizedBox(
                          height: 44,

                          child: ElevatedButton(
                            onPressed:
                                auth.isLoading
                                    ? null
                                    : _handleLogin,

                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.primary,
                              foregroundColor:
                                  Colors.white,
                              disabledBackgroundColor:
                                  AppColors.primary
                                      .withOpacity(0.6),
                              elevation: 0,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(9),
                              ),
                            ),

                            child: auth.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'ĐĂNG NHẬP  →',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 13),

                        // =================================================
                        // OR
                        // =================================================

                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Color(0xFFE3E7ED),
                              ),
                            ),

                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                'Hoặc tiếp tục với',
                                style: TextStyle(
                                  fontSize: 9,
                                  color:
                                      Color(0xFF7A8494),
                                ),
                              ),
                            ),

                            const Expanded(
                              child: Divider(
                                color: Color(0xFFE3E7ED),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // =================================================
                        // SOCIAL LOGIN
                        // =================================================

                        Row(
                          children: [
                            _buildSocialButton(
                              label: 'Google',
                              icon: const Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.w700,
                                  color: Color(0xFF4285F4),
                                ),
                              ),
                            ),

                            const SizedBox(width: 9),

                            _buildSocialButton(
                              label: 'Apple',
                              icon: const Icon(
                                Icons.apple,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(width: 9),

                            _buildSocialButton(
                              label: 'Facebook',
                              icon: const Icon(
                                Icons.facebook,
                                size: 20,
                                color: Color(0xFF1877F2),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // =================================================
                        // QUICK LOGIN ROLE CARD
                        // =================================================

                        Container(
                          padding: const EdgeInsets.all(9),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFE1E6EC),
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.bolt,
                                    size: 17,
                                    color:
                                        AppColors.primary,
                                  ),

                                  const SizedBox(width: 2),

                                  const Expanded(
                                    child: Text(
                                      'Đăng nhập nhanh theo vai trò',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight:
                                            FontWeight.w700,
                                        color:
                                            Color(0xFF202A38),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),

                                    decoration:
                                        BoxDecoration(
                                      color: const Color(
                                          0xFFFFF3E8),
                                      borderRadius:
                                          BorderRadius
                                              .circular(4),
                                    ),

                                    child: const Text(
                                      'DEMO',
                                      style: TextStyle(
                                        fontSize: 7,
                                        color:
                                            Color(0xFF9A5B22),
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 7),

                              // Row 1
                              Row(
                                children: [
                                  _buildRoleCard(
                                    title: 'Khách hàng',
                                    subtitle:
                                        'Gọi món ngon',
                                    email:
                                        'khach@gmail.com',
                                    icon:
                                        Icons.person_outline,
                                  ),

                                  const SizedBox(width: 7),

                                  _buildRoleCard(
                                    title: 'Chủ quán',
                                    subtitle:
                                        'Quản lý cửa hàng',
                                    email:
                                        'chuquan@gmail.com',
                                    icon:
                                        Icons.storefront_outlined,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 7),

                              // Row 2
                              Row(
                                children: [
                                  _buildRoleCard(
                                    title: 'Tài xế',
                                    subtitle:
                                        'Giao hàng tức thì',
                                    email:
                                        'taixe@gmail.com',
                                    icon:
                                        Icons.two_wheeler_outlined,
                                  ),

                                  const SizedBox(width: 7),

                                  _buildRoleCard(
                                    title: 'Admin',
                                    subtitle:
                                        'Quản trị viên',
                                    email:
                                        'admin@gmail.com',
                                    icon:
                                        Icons.shield_outlined,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 11),

                        // =================================================
                        // REGISTER
                        // =================================================

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: [
                            const Text(
                              'Chưa có tài khoản? ',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF687386),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                // TODO:
                                // Điều hướng RegisterScreen
                              },

                              child: const Text(
                                'Đăng ký ngay',
                                style: TextStyle(
                                  fontSize: 10,
                                  color:
                                      AppColors.primary,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // =================================================
                        // OLD DEMO BUTTONS
                        // Giữ lại theo yêu cầu.
                        // Có thể xóa sau khi hoàn thiện.
                        // =================================================

                        const SizedBox(height: 18),

                        const Divider(
                          color: Color(0xFFE5E7EB),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Tài khoản mẫu kiểm thử nhanh',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            color: Color(0xFF8A94A3),
                          ),
                        ),

                        const SizedBox(height: 5),

                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 5,
                          runSpacing: 4,
                          children: [
                            _buildOldDemoChip(
                              '👤 Khách hàng',
                              'khach@gmail.com',
                            ),
                            _buildOldDemoChip(
                              '🏪 Chủ quán',
                              'chuquan@gmail.com',
                            ),
                            _buildOldDemoChip(
                              '🛵 Tài xế',
                              'taixe@gmail.com',
                            ),
                            _buildOldDemoChip(
                              '🛡️ Admin',
                              'admin@gmail.com',
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),
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
}