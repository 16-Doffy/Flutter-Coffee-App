import 'package:flutter/material.dart';
import '../models/coffee_item.dart';
import '../models/shop_data.dart';
import '../widgets/animations.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedCategory = 0;
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  String _searchQuery = '';
  final _shop = ShopData.instance;
  late AnimationController _staggerController;

  List<CoffeeItem> get _filteredItems {
    final category = categoryNames[_selectedCategory];
    var items =
        allCoffeeItems.where((i) => i.category == category).toList();
    if (_searchQuery.isNotEmpty) {
      items = items
          .where((i) =>
              i.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  void _resetStagger() {
    _staggerController.reset();
    _staggerController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildCategoryChips(),
              const SizedBox(height: 24),
              const Text(
                "Today's Special",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 16),
              _buildPromoBanners(),
              const SizedBox(height: 12),
              _buildBannerIndicators(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    categoryNames[_selectedCategory],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  Text(
                    '${_filteredItems.length} items',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCoffeeList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Coffee Lover!',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            const Text(
              'Find the best coffee\nfor you',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D2D),
                height: 1.3,
              ),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFC67C4E).withValues(alpha: 0.15),
            border: Border.all(
              color: const Color(0xFFC67C4E).withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Color(0xFFC67C4E),
            size: 26,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search for coffee, drinks...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFC67C4E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryNames.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = index);
              _resetStagger();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFC67C4E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFC67C4E)
                      : Colors.grey[300]!,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFC67C4E)
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      categoryIcons[index],
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      categoryNames[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoBanners() {
    return SizedBox(
      height: 160,
      child: PageView(
        controller: _bannerController,
        onPageChanged: (i) => setState(() => _currentBanner = i),
        children: [
          _buildPromoBanner(
              '30% OFF',
              'Buy the best Coffee offer\nfor you from us',
              Icons.coffee_rounded),
          _buildPromoBanner(
              '20% OFF',
              'Special drinks collection\njust for you',
              Icons.local_cafe_rounded),
          _buildPromoBanner(
              'Buy 1 Get 1',
              'Amazing deals on\nall beverages',
              Icons.local_drink_rounded),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFC67C4E), Color(0xFF8B4513)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC67C4E).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                        height: 1.4)),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Buy now',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B4513),
                          fontSize: 13)),
                ),
              ],
            ),
          ),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
            ),
            child: Icon(icon, size: 45, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: index == _currentBanner ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: index == _currentBanner
                ? const Color(0xFFC67C4E)
                : const Color(0xFFD9D9D9),
          ),
        );
      }),
    );
  }

  Widget _buildCoffeeList() {
    final items = _filteredItems;
    if (items.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[300]),
              const SizedBox(height: 8),
              Text('No items found',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16)),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final startVal = (index * 0.15).clamp(0.0, 0.6);
          final endVal = (startVal + 0.5).clamp(0.0, 1.0);
          final anim = CurvedAnimation(
            parent: _staggerController,
            curve:
                Interval(startVal, endVal, curve: Curves.easeOutBack),
          );
          return FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.3, 0),
                end: Offset.zero,
              ).animate(anim),
              child: _buildCoffeeCard(items[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoffeeCard(CoffeeItem item) {
    return TapScaleEffect(
      onTap: () {
        Navigator.push(
          context,
          createSlideRoute(ProductDetailScreen(item: item)),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16, bottom: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'coffee_${item.id}',
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: item.gradientColors,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -15,
                      top: -15,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -10,
                      bottom: -10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Center(
                      child: Icon(item.icon, color: Colors.white, size: 48),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: ListenableBuilder(
                        listenable: _shop,
                        builder: (context, _) {
                          final isFav = _shop.isFavourite(item.id);
                          return GestureDetector(
                            onTap: () => _shop.toggleFavourite(item.id),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                key: ValueKey(isFav),
                                color: isFav ? Colors.red : Colors.white,
                                size: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF2D2D2D),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFA500), size: 16),
                      const SizedBox(width: 3),
                      Text(
                        '${item.rating}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC67C4E),
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          _shop.addToCart(item);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.name} added to cart'),
                              backgroundColor: const Color(0xFFC67C4E),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              duration: const Duration(milliseconds: 1200),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC67C4E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 16,
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
      ),
    );
  }
}
