import 'package:flutter/foundation.dart';
import 'coffee_item.dart';

class ShopData extends ChangeNotifier {
  static final ShopData instance = ShopData._();
  ShopData._();

  final List<CartItem> _cart = [];
  final Set<String> _favourites = {};

  List<CartItem> get cart => List.unmodifiable(_cart);
  Set<String> get favourites => Set.unmodifiable(_favourites);

  int get cartItemCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotal => _cart.fold(0.0, (sum, item) => sum + item.total);

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
}
