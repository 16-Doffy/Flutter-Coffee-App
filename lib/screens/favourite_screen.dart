import 'package:flutter/material.dart';
import '../models/coffee_item.dart';
import '../models/shop_data.dart';
import '../widgets/animations.dart';
import 'product_detail_screen.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with SingleTickerProviderStateMixin {
  final _shop = ShopData.instance;
  late AnimationController _gridController;
  String _filter = 'All';

  List<CoffeeItem> _getFilteredFavs() {
    final favItems =
        allCoffeeItems.where((i) => _shop.isFavourite(i.id)).toList();
    if (_filter == 'All') return favItems;
    return favItems.where((i) => i.category == _filter).toList();
  }

  @override
  void initState() {
    super.initState();
    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _gridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 16),
            Expanded(
              child: ListenableBuilder(
                listenable: _shop,
                builder: (context, _) {
                  final allFavs = allCoffeeItems
                      .where((i) => _shop.isFavourite(i.id))
                      .toList();
                  if (allFavs.isEmpty) {
                    return _buildEmpty();
                  }
                  final favItems = _getFilteredFavs();
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'My Favourites',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2D2D),
                              ),
                            ),
                            Text(
                              '${favItems.length} items',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildFilterChips(),
                      const SizedBox(height: 16),
                      if (favItems.isEmpty)
                        Expanded(
                          child: Center(
                            child: Text(
                              'No items in this category',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[400]),
                            ),
                          ),
                        )
                      else
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: favItems.length,
                            itemBuilder: (context, index) {
                              final startVal =
                                  (index * 0.1).clamp(0.0, 0.6);
                              final endVal =
                                  (startVal + 0.5).clamp(0.0, 1.0);
                              final anim = CurvedAnimation(
                                parent: _gridController,
                                curve: Interval(startVal, endVal,
                                    curve: Curves.easeOutBack),
                              );
                              return FadeTransition(
                                opacity: anim,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.2),
                                    end: Offset.zero,
                                  ).animate(anim),
                                  child:
                                      _buildProductCard(favItems[index]),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Text(
        'Favourite',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Hot Coffee', 'Drinks', 'Ice Cream', 'Tea'];
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = _filter == filters[index];
          return GestureDetector(
            onTap: () {
              setState(() => _filter = filters[index]);
              _gridController.reset();
              _gridController.forward();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF9A4F16)
                    : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF9A4F16)
                      : Colors.grey[300]!,
                ),
              ),
              child: Center(
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Icon(Icons.favorite_border_rounded,
                size: 80, color: Colors.grey[300]),
          ),
          const SizedBox(height: 16),
          Text(
            'No favourites yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon on items\nto add them here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(CoffeeItem item) {
    return TapScaleEffect(
      onTap: () {
        Navigator.push(
          context,
          createSlideRoute(ProductDetailScreen(item: item)),
        );
      },
      child: Container(
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
            Expanded(
              flex: 3,
              child: Hero(
                tag: 'coffee_${item.id}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: item.gradientColors,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -12,
                        top: -12,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: item.imagePath.isNotEmpty
                            ? ClipRRect(
                                borderRadius:
                                    const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.asset(
                                  item.imagePath,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(child: Icon(item.icon, color: Colors.white, size: 42)),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () => _shop.toggleFavourite(item.id),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Colors.white.withValues(alpha: 0.3),
                            ),
                            child: const Icon(Icons.favorite_rounded,
                                color: Colors.red, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Color(0xFF2D2D2D),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFFA500), size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${item.rating}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9A4F16),
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            _shop.addToCart(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${item.name} added to cart'),
                                backgroundColor:
                                    const Color(0xFF9A4F16),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10)),
                                duration: const Duration(
                                    milliseconds: 1200),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9A4F16),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
