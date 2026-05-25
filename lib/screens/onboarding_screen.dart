import 'package:flutter/material.dart';
import 'main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                children: [
                  _buildPage(
                    icon: Icons.coffee_rounded,
                    title: 'Cafe Shop',
                    subtitle:
                        'Find the best coffee for you, all you\nneeds coffee',
                  ),
                  _buildPage(
                    icon: Icons.local_cafe_rounded,
                    title: 'Fresh Brewed',
                    subtitle:
                        'Enjoy freshly brewed coffee\nevery morning',
                  ),
                  _buildPage(
                    icon: Icons.delivery_dining_rounded,
                    title: 'Fast Delivery',
                    subtitle:
                        'Get your coffee delivered\nright to your door',
                  ),
                ],
              ),
            ),
            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == _currentPage ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: index == _currentPage
                        ? const Color(0xFFC67C4E)
                        : const Color(0xFFD9D9D9),
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            // Bottom buttons
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _navigateToMain,
                    child: const Text(
                      'Skip Now',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _navigateToMain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC67C4E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
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

  Widget _buildPage({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 280,
          width: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFFC67C4E).withOpacity(0.15),
                Colors.transparent,
              ],
            ),
          ),
          child: Center(
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC67C4E).withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 80,
                color: const Color(0xFF8B4513),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF9E9E9E),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
