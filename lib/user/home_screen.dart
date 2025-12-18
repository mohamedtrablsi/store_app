import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../theme/app_colors.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';
import '../widgets/drawer_menu.dart';

import 'home_controller.dart';
import 'orders_screen.dart';

import 'pages/cart_page.dart';
import 'pages/explore_page.dart';
import 'pages/favorites_page.dart';
import 'pages/search_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final ProductService productService = ProductService();
  final HomeController controller = HomeController();

  int currentIndex = 0;
  List<ProductModel> allProducts = [];

  String _search = '';

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  void dispose() {
    controller.disposeController(); // ✅ مهم جداً
    super.dispose();
  }

  Future<String> _getUserName() async {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) return 'مستخدم';
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(u.uid)
        .get();
    return (doc.data()?['name'] ?? u.email ?? 'مستخدم').toString();
  }

  List<ProductModel> _filtered(List<ProductModel> list) {
    final q = _search.trim().toLowerCase();
    if (q.isEmpty) return list;
    return list.where((p) {
      final t = p.title.toLowerCase();
      final b = p.brand.toLowerCase();
      return t.contains(q) || b.contains(q);
    }).toList();
  }

  List<ProductModel> _byCategory(List<ProductModel> list, String categoryId) {
    // ✅ بدون ?? عشان ما يطلعش خطأ لو category مش nullable
    return list.where((p) => p.category == categoryId).toList();
  }

  // ✅ اختيار طريقة الدفع ثم checkout ثم رسالة نجاح جميلة
  Future<void> _startCheckout(BuildContext context) async {
    final method = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _PaymentSheet(),
    );

    if (!mounted) return;
    if (method == null) return;

    final ok = await controller.checkout(
      context: context,
      allProducts: allProducts,
      paymentMethod: method, // cash / card
    );

    if (!mounted) return;

    if (ok) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('✅ تم استلام طلبك'),
          content: Text(
            method == 'cash'
                ? 'طلبك تم تسجيله بنجاح، والدفع سيكون عند الاستلام.'
                : 'طلبك تم تسجيله بنجاح، وسيتم تأكيد الدفع قريباً.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('تمام'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.scaffoldDark,
        drawer: FutureBuilder<String>(
          future: _getUserName(),
          builder: (context, snap) {
            final name = snap.data ?? 'مستخدم';
            return DrawerMenu(
              userName: name,
              isAdmin: controller.isAdmin,
              onOrdersTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => OrdersScreen()),
                );
              },
            );
          },
        ),

        appBar: AppBar(
          backgroundColor: AppColors.scaffoldDark,
          elevation: 0,
          centerTitle: true,
          title: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ).createShader(bounds),
            child: const Text(
              'متجر نزار',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              onPressed: () => setState(() => currentIndex = 4),
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => setState(() => currentIndex = 3),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (_, __) {
                      final count = controller.totalCartCount();
                      if (count <= 0) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
          ],
        ),

        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return StreamBuilder<List<ProductModel>>(
              stream: productService.streamProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    controller.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                allProducts = snapshot.data ?? [];

                final pages = [
                  _homeView(_filtered(allProducts)),
                  const ExplorePage(),
                  FavoritesPage(
                    products: controller.favoriteProducts(allProducts),
                  ),
                  CartPage(
                    products: controller.cartProducts(allProducts),
                    quantities: controller.cartQuantities,
                    total: controller.cartTotalInt(allProducts).toDouble(),

                    onCheckout: () => _startCheckout(context), // ✅ مهم
                  ),
                  const SearchPage(),
                ];

                return pages[currentIndex];
              },
            );
          },
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: AppColors.cardDark,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          onTap: (i) => setState(() => currentIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'استكشاف',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'مفضلة'),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'السلة',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'بحث'),
          ],
        ),
      ),
    );
  }

  // ================== HOME VIEW ==================

  Widget _homeView(List<ProductModel> products) {
    final screens = _byCategory(products, 'screens');
    final phones = _byCategory(products, 'phones');
    final consoles = _byCategory(products, 'consoles');

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        const SizedBox(height: 6),
        const DealsBanner(),
        const SizedBox(height: 12),
        SearchBarCard(
          hint: 'دور على منتج… (شاشة، هاتف، PS5)',
          onChanged: (q) => setState(() => _search = q),
        ),
        const SizedBox(height: 16),

        _section(
          title: 'شاشات العرض الجديدة',
          icon: Icons.tv_rounded,
          items: screens,
        ),
        const SizedBox(height: 18),

        _section(
          title: 'أحدث الهواتف',
          icon: Icons.smartphone_rounded,
          items: phones,
        ),
        const SizedBox(height: 18),

        _section(
          title: 'أجهزة الألعاب 🎮',
          icon: Icons.sports_esports_rounded,
          items: consoles,
        ),
        const SizedBox(height: 18),

        if (screens.isEmpty && phones.isEmpty && consoles.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                'لا توجد منتجات حالياً',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

        const SizedBox(height: 12),
        Container(
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: AppColors.cardDark,
            border: Border.all(color: AppColors.borderSoft),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
                  ),
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'اسألني أي شيء… أنا هنا لمساعدتك ✨',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required List<ProductModel> items,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Text(
              '${items.length} عنصر',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 285,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, i) {
              final p = items[i];
              final outOfStock = p.stock <= 0;
              final qty = controller.quantityOf(p.id);
              final isFav = controller.isFavorite(p.id);

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _productCard(
                  p: p,
                  outOfStock: outOfStock,
                  qty: qty,
                  isFav: isFav,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ================== PRODUCT CARD ==================

  Widget _productCard({
    required ProductModel p,
    required bool outOfStock,
    required int qty,
    required bool isFav,
  }) {
    return SizedBox(
      width: 190,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                AppColors.cardDark,
                AppColors.cardDark.withOpacity(0.72),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(color: AppColors.borderSoft),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/${p.image}",
                      height: 125,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 125,
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: GestureDetector(
                        onTap: () => controller.toggleFavorite(p),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.redAccent : Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    if (outOfStock)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'نفاذ الكمية',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    p.brand,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${p.price} د.ل",
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: outOfStock
                        ? null
                        : () => controller.addOne(p, context),
                    child: Opacity(
                      opacity: outOfStock ? 0.4 : 1,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
                          ),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: outOfStock ? 0.4 : 1,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: outOfStock
                              ? null
                              : () => controller.removeOne(p),
                          child: _circleBtn(Icons.remove),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$qty",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: outOfStock
                              ? null
                              : () => controller.addOne(p, context),
                          child: _circleBtn(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _circleBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}

// ================== PAYMENT SHEET ==================

class _PaymentSheet extends StatelessWidget {
  const _PaymentSheet();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF111318),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'اختر طريقة الدفع',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            _tile(
              context,
              icon: Icons.money_rounded,
              title: 'كاش عند الاستلام',
              sub: 'الدفع وقت الاستلام',
              value: 'cash',
            ),
            const SizedBox(height: 10),
            _tile(
              context,
              icon: Icons.credit_card_rounded,
              title: 'بطاقة مصرفية',
              sub: 'تأكيد الدفع لاحقاً',
              value: 'card',
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String sub,
    required String value,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.pop(context, value),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E26),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
                ),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sub,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white38,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ================== DEALS + SEARCH ==================

class DealsBanner extends StatefulWidget {
  const DealsBanner({super.key});

  @override
  State<DealsBanner> createState() => _DealsBannerState();
}

class _DealsBannerState extends State<DealsBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final dy = lerpDouble(0, -6, Curves.easeInOut.transform(_c.value))!;
        return Transform.translate(
          offset: Offset(0, dy),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تخفيضات اليوم 🔥',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'خصومات قوية على الشاشات والهواتف',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_offer_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchBarCard extends StatefulWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const SearchBarCard({super.key, required this.hint, required this.onChanged});

  @override
  State<SearchBarCard> createState() => _SearchBarCardState();
}

class _SearchBarCardState extends State<SearchBarCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  );

  @override
  void initState() {
    super.initState();
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _c, curve: Curves.easeOut),
      child: ScaleTransition(
        scale: Tween(
          begin: 0.98,
          end: 1.0,
        ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutBack)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.borderSoft),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: const Icon(Icons.search_rounded, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  onChanged: widget.onChanged,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  cursorColor: Colors.orangeAccent,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
