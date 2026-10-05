import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AuthModeSwitch extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const AuthModeSwitch({
    super.key,
    required this.isLogin,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFE1E6EC),
        ),
      ),
      child: Row(
        children: [
          _item(
            text: 'Đăng Nhập',
            selected: isLogin,
            onTap: onLogin,
          ),
          _item(
            text: 'Đăng Ký',
            selected: !isLogin,
            onTap: onRegister,
          ),
        ],
      ),
    );
  }

  Widget _item({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : const Color(0xFF4B5563),
              ),
            ),
          ),
        ),
      ),
    );
  }
}