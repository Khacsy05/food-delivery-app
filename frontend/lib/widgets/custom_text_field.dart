import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final double labelFontSize;
  final double fieldHeight;
  final double borderRadius;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.labelFontSize = 14,
    this.fieldHeight = 50,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 5),

        SizedBox(
          height: fieldHeight,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            enableSuggestions: false,
            autocorrect: false,
            validator: validator,

            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textPrimary,
            ),

            decoration: InputDecoration(
              hintText: hintText,

              hintStyle: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
              ),

              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: AppColors.primary,
                      size: 17,
                    )
                  : null,

              suffixIcon: suffixIcon,

              filled: true,
              fillColor: Colors.white,

              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.border,
                ),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.border,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.3,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
