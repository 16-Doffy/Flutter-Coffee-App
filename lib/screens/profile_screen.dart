import 'package:flutter/material.dart';
import '../models/shop_data.dart';
import '../models/coffee_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final _shop = ShopData.instance;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _stagger(int index) {
    final start = (index * 0.1).clamp(0.0, 0.7);
    final end = (start + 0.4).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _animatedItem(0, _buildAvatar()),
              const SizedBox(height: 24),
              _animatedItem(1, _buildStats()),
              const SizedBox(height: 24),
              _animatedItem(2, _buildMenuSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animatedItem(int index, Widget child) {
    final anim = _stagger(index);
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }

  Widget _buildAvatar() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFC67C4E), Color(0xFF8B4513)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC67C4E).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.person_rounded, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text(
          'Coffee Lover',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'coffee.lover@email.com',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return ListenableBuilder(
      listenable: _shop,
      builder: (context, _) {
        return Row(
          children: [
            _buildStatCard(
              Icons.shopping_bag_rounded,
              '${_shop.cartItemCount}',
              'In Cart',
              const Color(0xFFC67C4E),
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              Icons.favorite_rounded,
              '${_shop.favourites.length}',
              'Favourites',
              Colors.red,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              Icons.coffee_rounded,
              '${allCoffeeItems.length}',
              'Menu Items',
              const Color(0xFF8B4513),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
      IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    final menuItems = [
      _MenuItem(Icons.receipt_long_rounded, 'Order History', 'View past orders'),
      _MenuItem(Icons.payment_rounded, 'Payment Methods', 'Manage cards'),
      _MenuItem(Icons.location_on_rounded, 'Delivery Address', 'Set address'),
      _MenuItem(Icons.notifications_rounded, 'Notifications', 'Preferences'),
      _MenuItem(Icons.settings_rounded, 'Settings', 'App settings'),
      _MenuItem(Icons.info_outline_rounded, 'About', 'App info'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: menuItems.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC67C4E).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon,
                          color: const Color(0xFFC67C4E), size: 22),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    subtitle: Text(
                      item.subtitle,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded,
                        color: Colors.grey[400]),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.title} - Coming soon!'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          duration: const Duration(milliseconds: 1000),
                        ),
                      );
                    },
                  ),
                  if (i < menuItems.length - 1)
                    Divider(height: 1, indent: 70, color: Colors.grey[200]),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  const _MenuItem(this.icon, this.title, this.subtitle);
}
