import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

class CustomerAccountScreen extends StatelessWidget {
  const CustomerAccountScreen({super.key});

  static const _roleNames = {
    'customer': 'Khách hàng',
    'merchant': 'Chủ quán',
    'shipper': 'Tài xế',
    'admin': 'Quản trị viên',
  };

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      children: [
        Text('Tài khoản', style: GoogleFonts.karla(
          color: AppColors.foreground, fontSize: 22, fontWeight: FontWeight.w800,
        )),
        const SizedBox(height: 16),
        _profileCard(user),
        const SizedBox(height: 22),
        Text('Vai trò của bạn', style: _sectionTitle),
        const SizedBox(height: 4),
        Text('Chọn giao diện bạn muốn sử dụng.', style: GoogleFonts.karla(
          color: AppColors.mutedForeground, fontSize: 12,
        )),
        const SizedBox(height: 10),
        ...user.roles.where(_roleNames.containsKey).map((role) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _roleTile(context, auth, user, role),
            )),
        const SizedBox(height: 14),
        _accountInfoCard(user),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: auth.isLoading ? null : () => auth.logout(),
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: const Text('Đăng xuất'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.destructive,
            minimumSize: const Size.fromHeight(48),
            side: BorderSide(color: AppColors.destructive.withOpacity(.35)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _profileCard(UserModel user) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(children: [
          ClipOval(
            child: SizedBox(
              width: 58,
              height: 58,
              child: Image.network(
                user.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _avatarFallback(user.name),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user.name.isEmpty ? 'Người dùng' : user.name,
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.karla(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.foreground)),
            const SizedBox(height: 3),
            Text(user.email, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.karla(fontSize: 12, color: AppColors.mutedForeground)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(.12), borderRadius: BorderRadius.circular(20)),
              child: Text(_roleNames[user.activeRole] ?? user.activeRole,
                style: GoogleFonts.karla(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.secondary)),
            ),
          ])),
        ]),
      );

  Widget _roleTile(BuildContext context, AuthProvider auth, UserModel user, String role) {
    final selected = user.activeRole == role;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: selected || auth.isLoading ? null : () => _switchRole(context, auth, role),
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.4 : 1),
          ),
          child: Row(children: [
            Icon(_roleIcons[role], color: selected ? AppColors.secondary : AppColors.mutedForeground, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(_roleNames[role]!, style: GoogleFonts.karla(
              fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.foreground,
            ))),
            if (auth.isLoading && !selected)
              const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2))
            else
              Icon(selected ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
                color: selected ? AppColors.primary : AppColors.mutedForeground, size: 19),
          ]),
        ),
      ),
    );
  }

  Widget _accountInfoCard(UserModel user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Column(children: [
          _infoRow(Icons.phone_outlined, 'Số điện thoại', user.phone.isEmpty ? 'Chưa cập nhật' : user.phone),
          const Divider(height: 1),
          _infoRow(Icons.location_on_outlined, 'Địa chỉ mặc định', user.defaultAddress?['street']?.toString() ?? 'Chưa có địa chỉ'),
        ]),
      );

  Widget _infoRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: GoogleFonts.karla(fontSize: 12, color: AppColors.mutedForeground))),
          Flexible(child: Text(value, textAlign: TextAlign.right, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: GoogleFonts.karla(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.foreground))),
        ]),
      );

  Future<void> _switchRole(BuildContext context, AuthProvider auth, String role) async {
    final success = await auth.switchRole(role);
    if (!context.mounted || success) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(auth.errorMessage ?? 'Không thể chuyển vai trò.'),
      behavior: SnackBarBehavior.floating,
    ));
  }

  Widget _avatarFallback(String name) => Container(
        color: AppColors.primary.withOpacity(.12),
        alignment: Alignment.center,
        child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'U', style: GoogleFonts.karla(
          color: AppColors.secondary, fontSize: 22, fontWeight: FontWeight.w800,
        )),
      );

  TextStyle get _sectionTitle => GoogleFonts.karla(
        color: AppColors.foreground, fontSize: 15, fontWeight: FontWeight.w800,
      );

  static const _roleIcons = {
    'customer': Icons.person_outline_rounded,
    'merchant': Icons.storefront_outlined,
    'shipper': Icons.delivery_dining_rounded,
    'admin': Icons.admin_panel_settings_outlined,
  };
}
