import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;

  const AuthHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F7F7),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.restaurant,
              color: Colors.white,
              size: 27,
            ),
          ),
        ),

        const SizedBox(height: 13),

        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Khám phá thế giới ẩm thực hấp dẫn ngay hôm nay',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            color: Color(0xFF687386),
          ),
        ),
      ],
    );
  }
}