import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/shop_data.dart';
import 'order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  final _shop = ShopData.instance;
  int _selectedPayment = 0;
  bool _saveCard = false;
  bool _isProcessing = false;
  late AnimationController _animController;

  final _cardNumberController =
      TextEditingController(text: '4242 4242 4242 4242');
  final _cardHolderController = TextEditingController(text: 'Coffee Lover');
  final _expiryController = TextEditingController(text: '12/26');
  final _cvcController = TextEditingController(text: '123');

  @override
  void initState() {
    super.initState();
    _selectedPayment = _shop.defaultPaymentIndex;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  double get _subtotal => _shop.cartTotal;
  double get _deliveryFee => _subtotal > 0 ? 3.00 : 0;
  double get _discount => _shop.discount;
  double get _tax => (_subtotal - _discount) * 0.08;
  double get _total => _subtotal + _deliveryFee + _tax - _discount;

  String get _paymentLabel {
    final methods = _shop.paymentMethods;
    if (_selectedPayment < methods.length) {
      final m = methods[_selectedPayment];
      return '${m.label} ${m.detail}';
    }
    return 'Cash';
  }

  void _processPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    final order = _shop.placeOrder(
      deliveryAddress: _shop.selectedAddress.address,
      paymentMethod: _paymentLabel,
    );

    setState(() => _isProcessing = false);
    _showPaymentSuccess(order.id);
  }

  void _showPaymentSuccess(String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PaymentSuccessDialog(
        onDone: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            this.context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  OrderTrackingScreen(orderId: orderId),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        },
      ),
    );
  }

  void _showAddressPicker() {
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
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Select Address',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              const SizedBox(height: 16),
              ...List.generate(_shop.addresses.length, (index) {
                final addr = _shop.addresses[index];
                final isSelected = _shop.selectedAddressIndex == index;
                return GestureDetector(
                  onTap: () {
                    _shop.selectAddress(index);
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
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(addr.icon,
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey[500],
                            size: 24),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(addr.label,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textDark,
                                  )),
                              const SizedBox(height: 4),
                              Text(addr.address,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.primary, size: 22),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textDark, size: 20),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(0, 'Delivery Address', _buildAddress()),
                      const SizedBox(height: 24),
                      _buildSection(
                          1, 'Payment Method', _buildPaymentMethods()),
                      const SizedBox(height: 24),
                      if (_selectedPayment == 0)
                        _buildSection(2, 'Card Details', _buildCardForm()),
                      if (_selectedPayment == 0) const SizedBox(height: 24),
                      _buildSection(
                          3, 'Order Items', _buildOrderItems()),
                      const SizedBox(height: 24),
                      _buildSection(4, 'Order Summary', _buildOrderSummary()),
                    ],
                  ),
                ),
              ),
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(int index, String title, Widget content) {
    final start = (index * 0.10).clamp(0.0, 0.6);
    final end = (start + 0.5).clamp(0.0, 1.0);
    final anim = CurvedAnimation(
      parent: _animController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
                .animate(anim),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                )),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildAddress() {
    final addr = _shop.selectedAddress;
    return GestureDetector(
      onTap: _showAddressPicker,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(addr.icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(addr.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.textDark,
                      )),
                  const SizedBox(height: 4),
                  Text(addr.address,
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.edit_rounded,
                  color: AppColors.primary, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final methods = _shop.paymentMethods;
    return Column(
      children: List.generate(methods.length, (index) {
        final m = methods[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index < methods.length - 1 ? 10 : 0),
          child: _buildPaymentOption(index, m.icon, m.label, m.detail),
        );
      }),
    );
  }

  Widget _buildPaymentOption(
      int index, IconData icon, String title, String subtitle) {
    final isSelected = _selectedPayment == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: isSelected ? AppColors.primary : Colors.grey[600],
                  size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textDark,
                      )),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? const Icon(Icons.check_circle_rounded,
                      key: ValueKey(true),
                      color: AppColors.primary,
                      size: 24)
                  : Icon(Icons.radio_button_off_rounded,
                      key: const ValueKey(false),
                      color: Colors.grey[400],
                      size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          _buildCardField('Card Number', _cardNumberController,
              Icons.credit_card_rounded),
          const SizedBox(height: 12),
          _buildCardField(
              'Card Holder', _cardHolderController, Icons.person_outline),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildCardField('Expiry', _expiryController,
                    Icons.calendar_today_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCardField(
                    'CVC', _cvcController, Icons.lock_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: _saveCard,
                onChanged: (v) => setState(() => _saveCard = v ?? false),
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              Text('Save card for future payments',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardField(
      String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),
        prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
      ),
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildOrderItems() {
    final items = _shop.cart;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient:
                        LinearGradient(colors: item.coffee.gradientColors),
                  ),
                  child: item.coffee.imagePath.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(item.coffee.imagePath,
                              fit: BoxFit.cover),
                        )
                      : Icon(item.coffee.icon,
                          color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.coffee.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14)),
                      Text('x${item.quantity}',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[500])),
                    ],
                  ),
                ),
                Text('\$${item.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          _summaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 10),
          _summaryRow('Delivery Fee', '\$${_deliveryFee.toStringAsFixed(2)}'),
          if (_discount > 0) ...[
            const SizedBox(height: 10),
            _summaryRow('Discount', '-\$${_discount.toStringAsFixed(2)}',
                isGreen: true),
          ],
          const SizedBox(height: 10),
          _summaryRow('Tax (8%)', '\$${_tax.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              Text('\$${_total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isGreen ? AppColors.success : AppColors.textDark)),
      ],
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: _isProcessing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : Text(
                    'Pay \$${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ),
    );
  }
}

class _PaymentSuccessDialog extends StatefulWidget {
  final VoidCallback onDone;
  const _PaymentSuccessDialog({required this.onDone});

  @override
  State<_PaymentSuccessDialog> createState() => _PaymentSuccessDialogState();
}

class _PaymentSuccessDialogState extends State<_PaymentSuccessDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _confettiController;
  late Animation<double> _scale;
  late Animation<double> _checkFade;
  late Animation<double> _confettiAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    _checkFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );
    _confettiAnim = CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOut,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _confettiController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _confettiAnim,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(140, 140),
                      painter: _RingPainter(
                        progress: _confettiAnim.value,
                        color: AppColors.success,
                      ),
                    );
                  },
                ),
                ScaleTransition(
                  scale: _scale,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withValues(alpha: 0.1),
                    ),
                    child: FadeTransition(
                      opacity: _checkFade,
                      child: const Icon(
                        Icons.check_circle_rounded,
                        size: 60,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order has been placed\nsuccessfully.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Tracking your order...',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primary.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = color.withValues(alpha: (1 - progress) * 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * (1 - progress);
    canvas.drawCircle(center, radius * progress, paint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
