import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/shop_data.dart';
import 'order_history_screen.dart';
import 'login_screen.dart';

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
      backgroundColor: AppColors.background,
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
              const SizedBox(height: 16),
              _animatedItem(3, _buildLogoutButton()),
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
              colors: [Color(0xFF9A4F16), Color(0xFF5D2E0A)],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
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
            color: AppColors.textDark,
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
              AppColors.primary,
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
              Icons.receipt_long_rounded,
              '${_shop.orders.length}',
              'Orders',
              AppColors.primaryDark,
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
      _MenuItem(Icons.receipt_long_rounded, 'Order History', 'View past orders',
          () => _navigateTo(const OrderHistoryScreen())),
      _MenuItem(Icons.payment_rounded, 'Payment Methods', 'Manage cards',
          () => _showPaymentMethods()),
      _MenuItem(Icons.location_on_rounded, 'Delivery Address', 'Set address',
          () => _showAddresses()),
      _MenuItem(Icons.notifications_rounded, 'Notifications', 'Preferences',
          () => _showSettings('Notifications')),
      _MenuItem(Icons.settings_rounded, 'Settings', 'App settings',
          () => _showSettings('Settings')),
      _MenuItem(Icons.info_outline_rounded, 'About', 'App info',
          () => _showAbout()),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
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
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon,
                          color: AppColors.primary, size: 22),
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
                    onTap: item.onTap,
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

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        },
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text('Logout',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _showPaymentMethods() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 20),
              const Text('Payment Methods',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              ..._shop.paymentMethods.asMap().entries.map((entry) {
                final i = entry.key;
                final m = entry.value;
                final isDefault = i == _shop.defaultPaymentIndex;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDefault ? AppColors.primary : Colors.grey[300]!,
                      width: isDefault ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: isDefault ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(m.icon,
                            color: isDefault ? AppColors.primary : Colors.grey[600], size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                            Text(m.detail, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                          ],
                        ),
                      ),
                      if (isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Default',
                              style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showAddresses() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 20),
              const Text('Delivery Addresses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              ..._shop.addresses.asMap().entries.map((entry) {
                final i = entry.key;
                final addr = entry.value;
                final isSelected = i == _shop.selectedAddressIndex;
                return GestureDetector(
                  onTap: () {
                    _shop.selectAddress(i);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(addr.icon,
                            color: isSelected ? AppColors.primary : Colors.grey[500], size: 24),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(addr.label,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? AppColors.primary : AppColors.textDark,
                                  )),
                              const SizedBox(height: 4),
                              Text(addr.address,
                                  style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showSettings(String section) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 20),
              Text(section,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              _settingsTile('Push Notifications', true),
              _settingsTile('Email Notifications', false),
              _settingsTile('Order Updates', true),
              _settingsTile('Promotions', true),
              if (section == 'Settings') ...[
                const Divider(height: 24),
                _settingsTile('Dark Mode', false),
                _settingsInfoTile('Language', 'English'),
                _settingsInfoTile('App Version', '1.0.0'),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _settingsTile(String title, bool defaultValue) {
    return StatefulBuilder(
      builder: (context, setLocal) {
        bool val = defaultValue;
        return SwitchListTile(
          title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          value: val,
          onChanged: (v) => setLocal(() => val = v),
          activeTrackColor: AppColors.primary.withValues(alpha: 0.4),
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }

  Widget _settingsInfoTile(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: Text(value, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset('assets/images/logo_third.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Third+ Coffee & Tea',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 4),
            Text('Version 1.0.0', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            const SizedBox(height: 12),
            Text('Your favourite coffee companion.\nBrewed with love.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _MenuItem(this.icon, this.title, this.subtitle, this.onTap);
}
