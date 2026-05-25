import 'package:flutter/material.dart';
import 'coffee_item.dart';

enum OrderStatus { pending, preparing, delivering, completed, cancelled }

class OrderItem {
  final CoffeeItem coffee;
  final int quantity;
  final String size;
  const OrderItem({required this.coffee, this.quantity = 1, this.size = 'M'});
  double get total => coffee.price * quantity;
}

class Order {
  final String id;
  final List<OrderItem> items;
  final double total;
  final DateTime createdAt;
  final String deliveryAddress;
  final String paymentMethod;
  OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.status = OrderStatus.pending,
  });

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);
}

class SavedAddress {
  final String id;
  final String label;
  final String address;
  final IconData icon;
  const SavedAddress({required this.id, required this.label, required this.address, required this.icon});
}

class SavedPaymentMethod {
  final String id;
  final String label;
  final String detail;
  final IconData icon;
  const SavedPaymentMethod({required this.id, required this.label, required this.detail, required this.icon});
}

class ShopData extends ChangeNotifier {
  static final ShopData instance = ShopData._();
  ShopData._();

  final List<CartItem> _cart = [];
  final Set<String> _favourites = {};
  final List<Order> _orders = [];
  String _promoCode = '';
  int _selectedAddressIndex = 0;
  int _defaultPaymentIndex = 0;

  final List<SavedAddress> _addresses = [
    const SavedAddress(id: 'a1', label: 'Home', address: '123 Coffee Street, Brew City, BC 12345', icon: Icons.home_rounded),
    const SavedAddress(id: 'a2', label: 'Office', address: '456 Business Ave, Brew City, BC 67890', icon: Icons.work_rounded),
  ];

  final List<SavedPaymentMethod> _paymentMethods = [
    const SavedPaymentMethod(id: 'p1', label: 'Visa', detail: '**** **** **** 4242', icon: Icons.credit_card_rounded),
    const SavedPaymentMethod(id: 'p2', label: 'MoMo', detail: 'Wallet linked', icon: Icons.account_balance_wallet_rounded),
    const SavedPaymentMethod(id: 'p3', label: 'Cash', detail: 'Pay on delivery', icon: Icons.money_rounded),
  ];

  List<CartItem> get cart => List.unmodifiable(_cart);
  Set<String> get favourites => Set.unmodifiable(_favourites);
  List<Order> get orders => List.unmodifiable(_orders);
  String get promoCode => _promoCode;
  List<SavedAddress> get addresses => List.unmodifiable(_addresses);
  List<SavedPaymentMethod> get paymentMethods => List.unmodifiable(_paymentMethods);
  int get selectedAddressIndex => _selectedAddressIndex;
  int get defaultPaymentIndex => _defaultPaymentIndex;
  SavedAddress get selectedAddress => _addresses[_selectedAddressIndex];

  void selectAddress(int index) {
    _selectedAddressIndex = index.clamp(0, _addresses.length - 1);
    notifyListeners();
  }

  void setDefaultPayment(int index) {
    _defaultPaymentIndex = index.clamp(0, _paymentMethods.length - 1);
    notifyListeners();
  }

  int get cartItemCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotal => _cart.fold(0.0, (sum, item) => sum + item.total);

  double get discount {
    if (_promoCode == 'COFFEE20') return cartTotal * 0.20;
    if (_promoCode == 'SAVE10') return cartTotal * 0.10;
    return 0.0;
  }

  void setPromoCode(String code) {
    _promoCode = code.toUpperCase().trim();
    notifyListeners();
  }

  void addToCart(CoffeeItem item, {int quantity = 1}) {
    final index = _cart.indexWhere((c) => c.coffee.id == item.id);
    if (index >= 0) {
      _cart[index].quantity += quantity;
    } else {
      _cart.add(CartItem(coffee: item, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    _cart.removeWhere((c) => c.coffee.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    final index = _cart.indexWhere((c) => c.coffee.id == id);
    if (index >= 0) {
      if (quantity <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    _promoCode = '';
    notifyListeners();
  }

  void toggleFavourite(String id) {
    if (_favourites.contains(id)) {
      _favourites.remove(id);
    } else {
      _favourites.add(id);
    }
    notifyListeners();
  }

  bool isFavourite(String id) => _favourites.contains(id);

  // Order management
  Order placeOrder({
    required String deliveryAddress,
    required String paymentMethod,
  }) {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toRadixString(36),
      items: _cart.map((c) => OrderItem(coffee: c.coffee, quantity: c.quantity)).toList(),
      total: cartTotal - discount,
      createdAt: DateTime.now(),
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
    );
    _orders.add(order);
    _cart.clear();
    _promoCode = '';
    notifyListeners();
    return order;
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0 && _orders[index].status != OrderStatus.completed) {
      _orders[index].status = OrderStatus.cancelled;
      notifyListeners();
    }
  }

  void reorderFromOrder(Order order) {
    for (final item in order.items) {
      addToCart(item.coffee, quantity: item.quantity);
    }
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _orders[index].status = status;
      notifyListeners();
    }
  }

  Order? getOrder(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }
}
