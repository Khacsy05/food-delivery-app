import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/auth_provider.dart';
import '../../constants/app_colors.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Tất cả', 'icon': Icons.restaurant_menu},
    {'name': 'Cơm', 'icon': Icons.rice_bowl_outlined},
    {'name': 'Bún / Phở', 'icon': Icons.ramen_dining_outlined},
    {'name': 'Trà Sữa', 'icon': Icons.local_cafe_outlined},
    {'name': 'Đồ Ăn Nhanh', 'icon': Icons.fastfood_outlined},
    {'name': 'Ăn Vặt', 'icon': Icons.bakery_dining_outlined},
  ];

  final List<Map<String, dynamic>> _mockFoods = [
    {
      'id': 'FOOD_001',
      'name': 'Cơm Sườn Nướng Đặc Biệt',
      'restaurant': 'Cơm Tấm Cali - Tây Sơn',
      'price': 45000,
      'originalPrice': 55000,
      'rating': 4.9,
      'ratingCount': 234,
      'distance': '1.2 km',
      'deliveryTime': '20-25 phút',
      'category': 'Cơm',
      'imageUrl': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&auto=format&fit=crop&q=80',
      'tag': 'Best Seller',
    },
    {
      'id': 'FOOD_002',
      'name': 'Cơm Gà Xối Mỡ Giòn Rụm',
      'restaurant': 'Cơm Tấm Cali - Tây Sơn',
      'price': 50000,
      'originalPrice': 60000,
      'rating': 4.7,
      'ratingCount': 120,
      'distance': '1.2 km',
      'deliveryTime': '20-30 phút',
      'category': 'Cơm',
      'imageUrl': 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=600&auto=format&fit=crop&q=80',
      'tag': 'Ưu Đãi Hot',
    },
    {
      'id': 'FOOD_003',
      'name': 'Trà Sữa Trân Châu Đường Đen',
      'restaurant': 'Trà Sữa Đô Đô - Chùa Bộc',
      'price': 35000,
      'originalPrice': 42000,
      'rating': 4.8,
      'ratingCount': 350,
      'distance': '0.8 km',
      'deliveryTime': '15-20 phút',
      'category': 'Trà Sữa',
      'imageUrl': 'https://images.unsplash.com/photo-1525385133512-2f3bdd039054?w=600&auto=format&fit=crop&q=80',
      'tag': 'Giảm 20%',
    },
    {
      'id': 'FOOD_004',
      'name': 'Phở Bò Tái Nạm Hà Nội',
      'restaurant': 'Phở Gia Truyền Bát Đàn',
      'price': 55000,
      'originalPrice': 65000,
      'rating': 4.9,
      'ratingCount': 410,
      'distance': '2.1 km',
      'deliveryTime': '25-35 phút',
      'category': 'Bún / Phở',
      'imageUrl': 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=600&auto=format&fit=crop&q=80',
      'tag': 'Truyền Thống',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onAddToCart(Map<String, dynamic> food) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Đã thêm "${food['name']}" vào giỏ hàng!',
                style: GoogleFonts.karla(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    final filteredFoods = _selectedCategoryIndex == 0
        ? _mockFoods
        : _mockFoods.where((f) => f['category'] == _categories[_selectedCategoryIndex]['name']).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. App Bar & Location Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Giao hàng đến',
                                style: GoogleFonts.karla(
                                  fontSize: 12,
                                  color: AppColors.mutedForeground,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.mutedForeground),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.defaultAddress?['street'] ?? '12 Chùa Bộc, Quang Trung, Đống Đa',
                            style: GoogleFonts.karla(
                              fontSize: 15,
                              color: AppColors.foreground,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => auth.logout(),
                      icon: const Icon(Icons.logout_rounded, color: AppColors.mutedForeground),
                      tooltip: 'Đăng xuất',
                    ),
                  ],
                ),
              ),
            ),

            // 2. Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.karla(fontSize: 15, color: AppColors.foreground),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm món ngon, quán ăn...',
                      hintStyle: GoogleFonts.karla(color: AppColors.mutedForeground, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 22),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 18),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),
            ),

            // 3. Hero Promo Banner (Vibrant Orange Block)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 140),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.32),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative background circle
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'ƯU ĐÃI ĐẶC QUYỀN',
                                      style: GoogleFonts.karla(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'GIẢM 50% ĐƠN ĐẦU',
                                    style: GoogleFonts.playfairDisplaySc(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.4,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Nhập mã FREESHIP • Tối đa 30K',
                                    style: GoogleFonts.karla(
                                      fontSize: 11,
                                      color: Colors.white.withOpacity(0.92),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Khám Phá',
                                style: GoogleFonts.karla(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 4. Section Title: Danh mục món ăn
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DANH MỤC MÓN ĂN',
                      style: GoogleFonts.playfairDisplaySc(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Tất cả',
                      style: GoogleFonts.karla(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 5. Category Chips (Horizontal Scrollable)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategoryIndex == index;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(22),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.card,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: 1.2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.28),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              cat['icon'] as IconData,
                              size: 16,
                              color: isSelected ? Colors.white : AppColors.mutedForeground,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              cat['name'],
                              style: GoogleFonts.karla(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.foreground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 6. Section Title: Món ngon đề xuất
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MÓN NGON GẦN BẠN',
                      style: GoogleFonts.playfairDisplaySc(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '${filteredFoods.length} món',
                      style: GoogleFonts.karla(
                        fontSize: 13,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 7. Food Cards List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final food = filteredFoods[index];
                    return _buildFoodCard(food);
                  },
                  childCount: filteredFoods.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image with Badge & Distance
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: food['imageUrl'],
                  height: 165,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 165,
                    color: AppColors.muted,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 165,
                    color: AppColors.muted,
                    child: const Icon(Icons.fastfood_outlined, color: AppColors.primary, size: 40),
                  ),
                ),
              ),
              // Promotion Tag
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    food['tag'],
                    style: GoogleFonts.karla(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Rating Badge
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${food['rating']} (${food['ratingCount']})',
                        style: GoogleFonts.karla(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Food Info & Price
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food['name'],
                  style: GoogleFonts.playfairDisplaySc(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.storefront_outlined, size: 14, color: AppColors.mutedForeground),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        food['restaurant'],
                        style: GoogleFonts.karla(
                          fontSize: 13,
                          color: AppColors.mutedForeground,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.near_me_outlined, size: 13, color: AppColors.primary),
                    const SizedBox(width: 3),
                    Text(
                      food['distance'],
                      style: GoogleFonts.karla(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time, size: 13, color: AppColors.mutedForeground),
                    const SizedBox(width: 3),
                    Text(
                      food['deliveryTime'],
                      style: GoogleFonts.karla(fontSize: 12, color: AppColors.mutedForeground),
                    ),
                  ],
                ),
                const Divider(height: 20, color: AppColors.border),
                // Price & Add to Cart CTA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${food['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ',
                          style: GoogleFonts.karla(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        if (food['originalPrice'] != null)
                          Text(
                            '${food['originalPrice'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ',
                            style: GoogleFonts.karla(
                              fontSize: 12,
                              color: AppColors.mutedForeground,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    // Action CTA Button (Design System: Accent CTA Blue or Primary)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent, // Trust Blue theo MASTER.md
                        foregroundColor: AppColors.onAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _onAddToCart(food),
                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                      label: Text(
                        'Thêm vào giỏ',
                        style: GoogleFonts.karla(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
