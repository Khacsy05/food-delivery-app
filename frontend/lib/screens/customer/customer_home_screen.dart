import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import 'customer_account_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedTab = 0;
  int _selectedCategory = 0;
  final _searchController = TextEditingController();
  final Set<String> _favoriteIds = {};

  final _categories = const [
    ('Tất cả', Icons.restaurant_menu),
    ('Cơm', Icons.rice_bowl_outlined),
    ('Mì & Bún', Icons.ramen_dining_outlined),
    ('Trà sữa', Icons.local_cafe_outlined),
    ('Đồ ăn nhanh', Icons.fastfood_outlined),
  ];

  final _foods = const [
    {
      'id': 'food_1',
      'name': 'Cơm Tấm Đặc Biệt',
      'restaurant': 'Cali Restaurant',
      'category': 'Cơm',
      'price': 53000,
      'oldPrice': 65000,
      'rating': '4.9 (120+ đánh giá)',
      'delivery': '20–25 phút · Miễn phí giao',
      'image': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=900&auto=format&fit=crop&q=85',
    },
    {
      'id': 'food_2',
      'name': 'Mì Trứng Xá Xíu',
      'restaurant': 'Hong Kong Kitchen',
      'category': 'Mì & Bún',
      'price': 65000,
      'oldPrice': null,
      'rating': '4.8 (95 đánh giá)',
      'delivery': '15–20 phút · Miễn phí giao',
      'image': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=900&auto=format&fit=crop&q=85',
    },
    {
      'id': 'food_3',
      'name': 'Trà Sữa Trân Châu',
      'restaurant': 'Trà Sữa Đô Đô',
      'category': 'Trà sữa',
      'price': 35000,
      'oldPrice': 42000,
      'rating': '4.8 (350 đánh giá)',
      'delivery': '15–20 phút · Phí giao 10K',
      'image': 'https://images.unsplash.com/photo-1525385133512-2f3bdd039054?w=900&auto=format&fit=crop&q=85',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _visibleFoods {
    final query = _searchController.text.trim().toLowerCase();
    return _foods.where((food) {
      final matchesCategory = _selectedCategory == 0 ||
          food['category'] == _categories[_selectedCategory].$1;
      final matchesSearch = query.isEmpty ||
          (food['name'] as String).toLowerCase().contains(query) ||
          (food['restaurant'] as String).toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTab,
          children: [
            _buildHome(user?.defaultAddress?['street'] as String?),
            const _EmptyTab(
              icon: Icons.receipt_long_outlined,
              title: 'Đơn hàng của bạn',
              subtitle: 'Các đơn hàng đã đặt sẽ xuất hiện ở đây.',
            ),
            _buildFavorites(),
            const CustomerAccountScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHome(String? address) {
    final foods = _visibleFoods;
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(address)),
        SliverToBoxAdapter(child: _buildSearch()),
        SliverToBoxAdapter(child: _buildPromotion()),
        SliverToBoxAdapter(child: _buildSectionTitle('Khám phá danh mục')),
        SliverToBoxAdapter(child: _buildCategories()),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Món ngon gần bạn', style: _headingStyle(16)),
                TextButton(
                  onPressed: () => setState(() => _selectedCategory = 0),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: Text('Xem tất cả', style: GoogleFonts.karla(
                    color: AppColors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  )),
                ),
              ],
            ),
          ),
        ),
        if (foods.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyTab(
              icon: Icons.search_off_rounded,
              title: 'Không tìm thấy món ăn',
              subtitle: 'Thử từ khóa hoặc danh mục khác nhé.',
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            sliver: SliverList.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) => _buildFoodCard(foods[index]),
            ),
          ),
      ],
    );
  }

  Widget _buildFavorites() {
    final foods = _foods.where((food) => _favoriteIds.contains(food['id'])).toList();
    if (foods.isEmpty) {
      return const _EmptyTab(
        icon: Icons.favorite_border_rounded,
        title: 'Món ăn yêu thích',
        subtitle: 'Chạm vào biểu tượng trái tim trên món ăn để lưu món.',
      );
    }
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Text('Món ăn yêu thích', style: _headingStyle(20)),
      )),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList.builder(
          itemCount: foods.length,
          itemBuilder: (context, index) => _buildFoodCard(foods[index]),
        ),
      ),
    ]);
  }

  Widget _buildHeader(String? address) {
    final auth = context.read<AuthProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 12, 8),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 19),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Giao đến', style: GoogleFonts.karla(
                  color: AppColors.mutedForeground, fontSize: 10,
                )),
                Row(children: [
                  Flexible(child: Text(
                    address?.isNotEmpty == true ? address! : '12 Chùa Bộc, Đống Đa',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.karla(
                      color: AppColors.foreground,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  )),
                  const Icon(Icons.keyboard_arrow_down, size: 16),
                ]),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Thông báo',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bạn chưa có thông báo mới.')),
            ),
            icon: const Badge(
              smallSize: 7,
              child: Icon(Icons.notifications_none_rounded, color: AppColors.foreground),
            ),
          ),
          IconButton(
            tooltip: 'Đăng xuất',
            onPressed: auth.logout,
            icon: const Icon(Icons.logout_rounded, color: AppColors.mutedForeground, size: 19),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: SizedBox(
          height: 44,
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Tìm món ăn, nhà hàng...',
              hintStyle: GoogleFonts.karla(fontSize: 12, color: AppColors.mutedForeground),
              prefixIcon: const Icon(Icons.search_rounded, size: 19, color: AppColors.mutedForeground),
              suffixIcon: IconButton(
                tooltip: 'Lọc danh mục',
                onPressed: () => setState(() => _selectedCategory = (_selectedCategory + 1) % _categories.length),
                icon: const Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
              ),
            ),
          ),
        ),
      );

  Widget _buildPromotion() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
        child: Container(
          height: 112,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFF37C8C1)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [BoxShadow(
              color: AppColors.primary.withOpacity(.22),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )],
          ),
          child: Stack(
            children: [
              const Positioned(
                right: 1, top: 0,
                child: Icon(Icons.restaurant, size: 48, color: Color(0x333FFFFFF)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ƯU ĐÃI ĐẶC BIỆT', style: GoogleFonts.karla(
                    color: Colors.white.withOpacity(.9), fontSize: 9,
                    fontWeight: FontWeight.w700, letterSpacing: .7,
                  )),
                  const SizedBox(height: 3),
                  Text('GIẢM 50% ĐƠN ĐẦU TIÊN', style: GoogleFonts.karla(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800,
                  )),
                  const SizedBox(height: 2),
                  Text('Áp dụng cho món ăn truyền thống hôm nay', style: GoogleFonts.karla(
                    color: Colors.white.withOpacity(.93), fontSize: 10,
                  )),
                  const SizedBox(height: 7),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => setState(() => _selectedCategory = 0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                        child: Text('Đặt ngay  ›', style: GoogleFonts.karla(
                          color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.w700,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
        child: Text(title, style: _headingStyle(15)),
      );

  Widget _buildCategories() => SizedBox(
        height: 38,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 7),
          itemBuilder: (context, index) {
            final category = _categories[index];
            final selected = index == _selectedCategory;
            return Material(
              color: selected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(22),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => setState(() => _selectedCategory = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: selected ? AppColors.primary : AppColors.border),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(category.$2, size: 14, color: selected ? Colors.white : AppColors.secondary),
                    const SizedBox(width: 5),
                    Text(category.$1, style: GoogleFonts.karla(
                      fontSize: 10, fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.foreground,
                    )),
                  ]),
                ),
              ),
            );
          },
        ),
      );

  Widget _buildFoodCard(Map<String, dynamic> food) {
    final id = food['id'] as String;
    final favorite = _favoriteIds.contains(id);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(13),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 118,
          width: double.infinity,
          child: Stack(fit: StackFit.expand, children: [
            CachedNetworkImage(
              imageUrl: food['image'] as String,
              fit: BoxFit.cover,
              placeholder: (_, __) => const ColoredBox(color: AppColors.muted),
              errorWidget: (_, __, ___) => const ColoredBox(
                color: AppColors.muted,
                child: Icon(Icons.restaurant, color: AppColors.primary, size: 34),
              ),
            ),
            Positioned(
              left: 8, bottom: 7,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(color: Colors.black.withOpacity(.65), borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFC857)),
                  const SizedBox(width: 3),
                  Text(food['rating'] as String, style: GoogleFonts.karla(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
            Positioned(
              top: 7, right: 7,
              child: Material(
                color: Colors.white.withOpacity(.94),
                shape: const CircleBorder(),
                child: IconButton(
                  constraints: const BoxConstraints.tightFor(width: 34, height: 34),
                  padding: EdgeInsets.zero,
                  tooltip: favorite ? 'Bỏ yêu thích' : 'Thêm yêu thích',
                  onPressed: () => setState(() {
                    favorite ? _favoriteIds.remove(id) : _favoriteIds.add(id);
                  }),
                  icon: Icon(favorite ? Icons.favorite : Icons.favorite_border,
                    size: 18, color: favorite ? AppColors.destructive : AppColors.mutedForeground),
                ),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 7, 10, 9),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(food['restaurant'] as String, style: GoogleFonts.karla(
                color: AppColors.secondary, fontSize: 9, fontWeight: FontWeight.w700,
              ))),
              const Icon(Icons.schedule_rounded, size: 11, color: AppColors.mutedForeground),
              const SizedBox(width: 3),
              Text(food['delivery'] as String, style: GoogleFonts.karla(
                color: AppColors.mutedForeground, fontSize: 8,
              )),
            ]),
            const SizedBox(height: 3),
            Text(food['name'] as String, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.karla(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.foreground)),
            const SizedBox(height: 6),
            Row(children: [
              Text('${_formatPrice(food['price'] as int)}đ', style: GoogleFonts.karla(
                fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.secondary,
              )),
              if (food['oldPrice'] != null) ...[
                const SizedBox(width: 5),
                Text('${_formatPrice(food['oldPrice'] as int)}đ', style: GoogleFonts.karla(
                  fontSize: 8, color: AppColors.mutedForeground, decoration: TextDecoration.lineThrough,
                )),
              ],
              const Spacer(),
              SizedBox(
                height: 30,
                child: FilledButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã thêm ${food['name']} vào giỏ hàng.')),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(Icons.add, size: 14),
                  label: Text('Thêm vào giỏ', style: GoogleFonts.karla(fontSize: 9, fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _buildBottomNavigation() {
    const items = [
      (Icons.home_outlined, Icons.home_rounded, 'Trang chủ'),
      (Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Đơn hàng'),
      (Icons.favorite_border_rounded, Icons.favorite_rounded, 'Yêu thích'),
      (Icons.person_outline_rounded, Icons.person_rounded, 'Tài khoản'),
    ];
    return SafeArea(
      top: false,
      child: Container(
        height: 58,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = _selectedTab == index;
          return Expanded(
            child: Semantics(
              button: true,
              selected: selected,
              label: item.$3,
              child: InkWell(
                onTap: () => setState(() => _selectedTab = index),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(selected ? item.$2 : item.$1, size: 19,
                    color: selected ? AppColors.primary : AppColors.mutedForeground),
                  const SizedBox(height: 2),
                  Text(item.$3, style: GoogleFonts.karla(
                    fontSize: 8,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? AppColors.secondary : AppColors.mutedForeground,
                  )),
                ]),
              ),
            ),
          );
        })),
      ),
    );
  }

  TextStyle _headingStyle(double size) => GoogleFonts.karla(
        color: AppColors.foreground,
        fontSize: size,
        fontWeight: FontWeight.w800,
      );

  String _formatPrice(int price) => price.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]}.',
      );
}

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 48, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: GoogleFonts.karla(
              fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.foreground,
            )),
            const SizedBox(height: 5),
            Text(subtitle, textAlign: TextAlign.center, style: GoogleFonts.karla(
              fontSize: 13, color: AppColors.mutedForeground,
            )),
          ]),
        ),
      );
}
