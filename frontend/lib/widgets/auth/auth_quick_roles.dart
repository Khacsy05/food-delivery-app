import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class DemoAccount {
  final String title;
  final String subtitle;
  final String email;
  final IconData icon;

  const DemoAccount({
    required this.title,
    required this.subtitle,
    required this.email,
    required this.icon,
  });
}

class AuthQuickRoles extends StatelessWidget {
  final ValueChanged<DemoAccount> onSelected;

  const AuthQuickRoles({
    super.key,
    required this.onSelected,
  });

  static const accounts = [
    DemoAccount(
      title: 'Khách hàng',
      subtitle: 'Gọi món ngon',
      email: 'khach@gmail.com',
      icon: Icons.person_outline,
    ),
    DemoAccount(
      title: 'Chủ quán',
      subtitle: 'Quản lý cửa hàng',
      email: 'chuquan@gmail.com',
      icon: Icons.storefront_outlined,
    ),
    DemoAccount(
      title: 'Tài xế',
      subtitle: 'Giao hàng tức thì',
      email: 'taixe@gmail.com',
      icon: Icons.two_wheeler_outlined,
    ),
    DemoAccount(
      title: 'Admin',
      subtitle: 'Quản trị viên',
      email: 'admin@gmail.com',
      icon: Icons.shield_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE1E6EC),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.bolt,
                size: 17,
                color: AppColors.primary,
              ),
              const SizedBox(width: 3),
              const Expanded(
                child: Text(
                  'Đăng nhập nhanh theo vai trò',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF202A38),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'DEMO',
                  style: TextStyle(
                    fontSize: 7,
                    color: Color(0xFF9A5B22),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          Row(
            children: [
              Expanded(
                child: _RoleCard(
                  account: accounts[0],
                  onTap: () =>
                      onSelected(accounts[0]),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _RoleCard(
                  account: accounts[1],
                  onTap: () =>
                      onSelected(accounts[1]),
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          Row(
            children: [
              Expanded(
                child: _RoleCard(
                  account: accounts[2],
                  onTap: () =>
                      onSelected(accounts[2]),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _RoleCard(
                  account: accounts[3],
                  onTap: () =>
                      onSelected(accounts[3]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final DemoAccount account;
  final VoidCallback onTap;

  const _RoleCard({
    required this.account,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: 54,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: const Color(0xFFE1E6EC),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F8F8),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                account.icon,
                size: 15,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    account.title,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    account.subtitle,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 7,
                      color: Color(0xFF7A8494),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}