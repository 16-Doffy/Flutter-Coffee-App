import 'package:flutter/material.dart';

class CoffeeItem {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String category;
  final String description;
  final List<Color> gradientColors;
  final IconData icon;
  final String imagePath;

  const CoffeeItem({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.category,
    required this.description,
    required this.gradientColors,
    required this.icon,
    this.imagePath = '',
  });
}

class CartItem {
  final CoffeeItem coffee;
  int quantity;

  CartItem({required this.coffee, this.quantity = 1});

  double get total => coffee.price * quantity;
}

const List<String> categoryNames = [
  'Hot Coffee',
  'Drinks',
  'Ice Cream',
  'Tea',
];

const List<IconData> categoryIcons = [
  Icons.coffee_rounded,
  Icons.local_drink_rounded,
  Icons.icecream_rounded,
  Icons.emoji_food_beverage_rounded,
];

final List<CoffeeItem> allCoffeeItems = const [
  CoffeeItem(
    id: 'hc1',
    name: 'Cafe Latte',
    price: 15.00,
    rating: 4.5,
    category: 'Hot Coffee',
    description:
        'A smooth and creamy coffee made with espresso and steamed milk, topped with a light layer of foam. Perfect balance of coffee and milk.',
    gradientColors: [Color(0xFFBE8C63), Color(0xFF8B5E3C)],
    icon: Icons.coffee_rounded,
    imagePath: 'assets/images/latte.png',
  ),
  CoffeeItem(
    id: 'hc2',
    name: 'Cappuccino',
    price: 20.00,
    rating: 5.0,
    category: 'Hot Coffee',
    description:
        'Rich espresso blended with steamed milk and a deep layer of velvety foam. A classic Italian favorite for coffee lovers.',
    gradientColors: [Color(0xFFA0522D), Color(0xFF6F4E37)],
    icon: Icons.coffee_rounded,
    imagePath: 'assets/images/cappuccino.png',
  ),
  CoffeeItem(
    id: 'hc3',
    name: 'Americano',
    price: 12.00,
    rating: 4.5,
    category: 'Hot Coffee',
    description:
        'Espresso diluted with hot water, giving it a similar strength to drip coffee but with a richer, bolder flavor profile.',
    gradientColors: [Color(0xFF6D4C41), Color(0xFF4E342E)],
    icon: Icons.coffee_rounded,
    imagePath: 'assets/images/americano.png',
  ),
  CoffeeItem(
    id: 'hc4',
    name: 'Espresso',
    price: 10.00,
    rating: 4.8,
    category: 'Hot Coffee',
    description:
        'A concentrated shot of pure coffee. Bold, intense, and full of rich aromatic flavor. The foundation of all great coffee drinks.',
    gradientColors: [Color(0xFF4E342E), Color(0xFF3E2723)],
    icon: Icons.coffee_rounded,
    imagePath: 'assets/images/americano.png',
  ),
  CoffeeItem(
    id: 'hc5',
    name: 'Mocha',
    price: 18.00,
    rating: 4.2,
    category: 'Hot Coffee',
    description:
        'A chocolate-flavored variant of a latte combining espresso, hot milk, chocolate syrup, and topped with whipped cream.',
    gradientColors: [Color(0xFF8D6E63), Color(0xFF5D4037)],
    icon: Icons.coffee_rounded,
    imagePath: 'assets/images/mocha.png',
  ),

  CoffeeItem(
    id: 'hc6',
    name: 'Caramel Latte',
    price: 22.00,
    rating: 4.8,
    category: 'Hot Coffee',
    description:
        'Creamy latte blended with sweet caramel syrup and topped with soft foam. A cozy signature drink for Third+ lovers.',
    gradientColors: [Color(0xFFD39B6A), Color(0xFF9A4F16)],
    icon: Icons.coffee_rounded,
    imagePath: 'assets/images/caramel_latte.png',
  ),
  CoffeeItem(
    id: 'hc7',
    name: 'Cold Brew',
    price: 25.00,
    rating: 4.6,
    category: 'Hot Coffee',
    description:
        'Slow-steeped coffee served chilled for a smooth, bold, less acidic flavor. Perfect for hot days.',
    gradientColors: [Color(0xFF5D4037), Color(0xFF2E1B12)],
    icon: Icons.coffee_rounded,
    imagePath: 'assets/images/cold_brew.png',
  ),
  CoffeeItem(
    id: 'd1',
    name: 'Iced Tea',
    price: 10.00,
    rating: 4.2,
    category: 'Drinks',
    description:
        'Refreshing chilled tea with a hint of lemon and mint. The perfect drink for hot summer days.',
    gradientColors: [Color(0xFF66BB6A), Color(0xFF388E3C)],
    icon: Icons.local_drink_rounded,
    imagePath: 'assets/images/strawberry_tea.png',
  ),
  CoffeeItem(
    id: 'd2',
    name: 'Berry Smoothie',
    price: 18.00,
    rating: 4.7,
    category: 'Drinks',
    description:
        'A blend of mixed berries, yogurt, and ice. Sweet, tangy, and packed with vitamins and antioxidants.',
    gradientColors: [Color(0xFFE91E63), Color(0xFFC2185B)],
    icon: Icons.local_drink_rounded,
    imagePath: 'assets/images/strawberry_tea.png',
  ),
  CoffeeItem(
    id: 'd3',
    name: 'Fresh Orange',
    price: 14.00,
    rating: 4.3,
    category: 'Drinks',
    description:
        'Freshly squeezed orange juice packed with vitamin C. Pure, natural, and bursting with citrus flavor.',
    gradientColors: [Color(0xFFFF9800), Color(0xFFF57C00)],
    icon: Icons.local_drink_rounded,
    imagePath: 'assets/images/strawberry_tea.png',
  ),
  CoffeeItem(
    id: 'd4',
    name: 'Lemonade',
    price: 8.00,
    rating: 4.0,
    category: 'Drinks',
    description:
        'Classic lemonade made with fresh lemons, a touch of sugar, and sparkling water for that perfect fizz.',
    gradientColors: [Color(0xFFFFD54F), Color(0xFFFBC02D)],
    icon: Icons.local_drink_rounded,
    imagePath: 'assets/images/strawberry_tea.png',
  ),

  CoffeeItem(
    id: 'd5',
    name: 'Matcha Latte',
    price: 22.00,
    rating: 4.7,
    category: 'Drinks',
    description:
        'Premium matcha mixed with fresh milk for a rich green tea flavor and smooth creamy finish.',
    gradientColors: [Color(0xFF9CCC65), Color(0xFF558B2F)],
    icon: Icons.local_drink_rounded,
    imagePath: 'assets/images/matcha_latte.png',
  ),
  CoffeeItem(
    id: 'd6',
    name: 'Strawberry Tea',
    price: 20.00,
    rating: 4.7,
    category: 'Drinks',
    description:
        'Fresh strawberry tea with fruity aroma, light sweetness, and a refreshing finish.',
    gradientColors: [Color(0xFFF8A5B7), Color(0xFFE75480)],
    icon: Icons.local_drink_rounded,
    imagePath: 'assets/images/strawberry_tea.png',
  ),
  CoffeeItem(
    id: 'ic1',
    name: 'Vanilla Scoop',
    price: 8.00,
    rating: 4.6,
    category: 'Ice Cream',
    description:
        'Classic vanilla ice cream made with real Madagascar vanilla beans. Smooth, creamy, and irresistible.',
    gradientColors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
    icon: Icons.icecream_rounded,
    imagePath: 'assets/images/caramel_latte.png',
  ),
  CoffeeItem(
    id: 'ic2',
    name: 'Chocolate Sundae',
    price: 12.00,
    rating: 4.9,
    category: 'Ice Cream',
    description:
        'Rich chocolate ice cream drizzled with hot fudge sauce, topped with whipped cream and a cherry.',
    gradientColors: [Color(0xFF795548), Color(0xFF4E342E)],
    icon: Icons.icecream_rounded,
    imagePath: 'assets/images/mocha.png',
  ),
  CoffeeItem(
    id: 'ic3',
    name: 'Strawberry Gelato',
    price: 10.00,
    rating: 4.4,
    category: 'Ice Cream',
    description:
        'Italian-style gelato made with fresh strawberries. Light, refreshing, and bursting with fruity flavor.',
    gradientColors: [Color(0xFFF48FB1), Color(0xFFE91E63)],
    icon: Icons.icecream_rounded,
    imagePath: 'assets/images/strawberry_tea.png',
  ),
  CoffeeItem(
    id: 't1',
    name: 'Green Tea',
    price: 8.00,
    rating: 4.3,
    category: 'Tea',
    description:
        'Traditional Japanese green tea. Light, refreshing, and packed with antioxidants for a healthy boost.',
    gradientColors: [Color(0xFF81C784), Color(0xFF4CAF50)],
    icon: Icons.emoji_food_beverage_rounded,
    imagePath: 'assets/images/matcha_latte.png',
  ),
  CoffeeItem(
    id: 't2',
    name: 'Chai Latte',
    price: 14.00,
    rating: 4.5,
    category: 'Tea',
    description:
        'Aromatic spiced tea with steamed milk. A warm blend of cinnamon, cardamom, ginger, and black tea.',
    gradientColors: [Color(0xFFBCAAA4), Color(0xFF8D6E63)],
    icon: Icons.emoji_food_beverage_rounded,
    imagePath: 'assets/images/caramel_latte.png',
  ),
  CoffeeItem(
    id: 't3',
    name: 'Earl Grey',
    price: 9.00,
    rating: 4.1,
    category: 'Tea',
    description:
        'A fragrant black tea flavored with oil of bergamot. Elegant, aromatic, and perfect for afternoon tea.',
    gradientColors: [Color(0xFF90A4AE), Color(0xFF546E7A)],
    icon: Icons.emoji_food_beverage_rounded,
    imagePath: 'assets/images/cold_brew.png',
  ),
];
