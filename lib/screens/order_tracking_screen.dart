import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/shop_data.dart';
import 'main_screen.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _progressController;
  final _shop = ShopData.instance;
  int _currentStep = 0;

  final List<_TrackingStep> _steps = const [
    _TrackingStep(
      icon: Icons.receipt_long_rounded,
      title: 'Order Confirmed',
      subtitle: 'Your order has been placed',
      time: 'Just now',
    ),
    _TrackingStep(
      icon: Icons.coffee_maker_rounded,
      title: 'Preparing',
      subtitle: 'Your coffee is being prepared',
      time: '~5 min',
    ),
    _TrackingStep(
      icon: Icons.delivery_dining_rounded,
      title: 'On the Way',
      subtitle: 'Rider is heading to you',
      time: '~15 min',
    ),
    _TrackingStep(
      icon: Icons.check_circle_rounded,
      title: 'Delivered',
      subtitle: 'Enjoy your coffee!',
      time: '~25 min',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _simulateProgress();
  }

  void _simulateProgress() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _currentStep = 1);
      _progressController.forward(from: 0);
    }
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _currentStep = 2);
      _progressController.forward(from: 0);
    }
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      setState(() => _currentStep = 3);
      _progressController.forward(from: 0);
      _shop.updateOrderStatus(widget.orderId, OrderStatus.completed);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = _shop.getOrder(widget.orderId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
              (route) => false,
            );
          },
          icon: const Icon(Icons.close_rounded,
              color: AppColors.textDark, size: 24),
        ),
        title: const Text(
          'Order Tracking',
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildMapPlaceholder(),
                const SizedBox(height: 20),
                _buildProgressBar(),
                const SizedBox(height: 20),
                _buildEstimatedTime(),
                const SizedBox(height: 20),
                _buildTimeline(),
                const SizedBox(height: 20),
                if (_currentStep >= 2) _buildDriverCard(),
                if (_currentStep >= 2) const SizedBox(height: 20),
                if (order != null) _buildDeliveryInfo(order),
                const SizedBox(height: 24),
                _buildBackButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    final anim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: anim,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.08),
              AppColors.primaryLight.withValues(alpha: 0.15),
            ],
          ),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
        ),
        child: Stack(
          children: [
            // Grid pattern
            CustomPaint(
              size: const Size(double.infinity, 180),
              painter: _MapGridPainter(),
            ),
            // Animated route line
            Center(
              child: CustomPaint(
                size: const Size(double.infinity, 180),
                painter: _RoutePainter(step: _currentStep),
              ),
            ),
            // Origin pin
            Positioned(
              left: 40,
              bottom: 50,
              child: _buildMapPin(Icons.store_rounded, 'Shop'),
            ),
            // Destination pin
            Positioned(
              right: 40,
              top: 30,
              child: _buildMapPin(Icons.home_rounded, 'You'),
            ),
            // Rider icon (moving)
            if (_currentStep >= 2)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                left: _currentStep >= 3 ? 260 : 150,
                top: _currentStep >= 3 ? 40 : 80,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) =>
                      Transform.scale(scale: value, child: child),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.delivery_dining_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPin(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progress = (_currentStep / 3).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${widget.orderId.substring(0, 8).toUpperCase()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey[200],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 8,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _steps[_currentStep].subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(_steps.length, (index) {
          final step = _steps[index];
          final isCompleted = index <= _currentStep;
          final isActive = index == _currentStep;
          final isLast = index == _steps.length - 1;

          return Column(
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppColors.primary
                          : Colors.grey[200],
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color:
                                    AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      step.icon,
                      color: isCompleted ? Colors.white : Colors.grey[400],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: TextStyle(
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.w500,
                            fontSize: 14,
                            color: isCompleted
                                ? AppColors.textDark
                                : Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          step.subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: isCompleted
                                ? Colors.grey[600]
                                : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted && !isActive)
                    const Icon(Icons.check_rounded,
                        color: AppColors.success, size: 18),
                  if (isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        step.time,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 2,
                    height: 28,
                    color: isCompleted && index < _currentStep
                        ? AppColors.primary
                        : Colors.grey[200],
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEstimatedTime() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primaryLight.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child:
                const Icon(Icons.timer_rounded, color: AppColors.primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Estimated Delivery',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(height: 2),
                Text(
                  _currentStep >= 3 ? 'Delivered!' : '15 - 25 min',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          if (_currentStep >= 3)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check_rounded, color: Colors.white, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildDriverCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF9A4F16), Color(0xFF5D2E0A)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child:
                  const Icon(Icons.person_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Minh Nguyen',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textDark)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFA500), size: 14),
                      const SizedBox(width: 3),
                      Text('4.9',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(width: 8),
                      Text('·  Delivery Partner',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[500])),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.phone_rounded,
                  color: AppColors.success, size: 20),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.chat_rounded,
                  color: AppColors.primary, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo(Order order) {
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
          _infoRow(Icons.location_on_outlined, 'Address',
              order.deliveryAddress),
          const Divider(height: 20),
          _infoRow(Icons.payment_rounded, 'Payment', order.paymentMethod),
          const Divider(height: 20),
          _infoRow(Icons.shopping_bag_outlined, 'Items',
              '${order.itemCount} item(s)'),
          const Divider(height: 20),
          _infoRow(Icons.attach_money_rounded, 'Total',
              '\$${order.total.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
            (route) => false,
          );
        },
        icon: const Icon(Icons.home_rounded, size: 20),
        label: const Text('Back to Home',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }
}

class _TrackingStep {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  const _TrackingStep(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.time});
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9A4F16).withValues(alpha: 0.06)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePainter extends CustomPainter {
  final int step;
  _RoutePainter({required this.step});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9A4F16).withValues(alpha: 0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(70, size.height - 40);
    path.cubicTo(
      size.width * 0.3,
      size.height * 0.6,
      size.width * 0.6,
      size.height * 0.3,
      size.width - 60,
      55,
    );

    // Draw dashed line
    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = (distance + 8).clamp(0.0, metric.length);
        dashPath.addPath(metric.extractPath(distance, next), Offset.zero);
        distance += 16;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) =>
      oldDelegate.step != step;
}
