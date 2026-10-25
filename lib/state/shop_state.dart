import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../models/product.dart';

class ShopState extends ChangeNotifier {
  final Map<String, int> _cart = {};
  final Set<String> _wishlist = {'brown', 'cream', 'sunglasses', 'earrings'};
  final List<Order> _orders = [];
  Map<String, int> get cart => Map.unmodifiable(_cart);
  Set<String> get wishlist => Set.unmodifiable(_wishlist);
  List<Order> get orders => List.unmodifiable(_orders);
  Product selectedProduct = products[2];
  String username = 'Brandi Willz';
  String email = 'brandi@example.com';
  String query = '', category = 'Bags', filterColor = '';
  RangeValues priceRange = const RangeValues(0, 5000);
  double minRating = 0;
  bool darkMode = false, notifications = true, newsletter = false;
  int shipping = 0;
  String address = '1550 Jerome Avenue, Harlingen, Texas';
  static const shippingNames = ['Regular', 'Fast & Secure', 'Ultra Fast'];
  static const shippingPrices = [0, 25, 100];
  int get subtotal =>
      _cart.entries.fold(0, (sum, e) => sum + product(e.key).price * e.value);
  int get quantity => _cart.values.fold(0, (sum, value) => sum + value);
  int get shippingPrice => shippingPrices[shipping];
  int get total => subtotal + shippingPrice;
  Product product(String id) => products.firstWhere((p) => p.id == id);

  List<Product> get filteredProducts => products
      .where(
        (p) =>
            (category == 'All' || p.category == category) &&
            p.price >= priceRange.start &&
            p.price <= priceRange.end &&
            p.rating >= minRating &&
            (filterColor.isEmpty ||
                switch (filterColor) {
                  'Black' => [
                    'black',
                    'sunglasses',
                    'watch',
                    'beauty',
                  ].contains(p.id),
                  'Cream' => p.id == 'cream',
                  'Brown' => ['brown', 'croc'].contains(p.id),
                  _ => true,
                }),
      )
      .toList();
  List<Product> get searchResults => products
      .where(
        (p) => '${p.name} ${p.category} ${p.material}'.toLowerCase().contains(
          query.trim().toLowerCase(),
        ),
      )
      .toList();

  void refresh() => notifyListeners();
  void add(Product p, [int quantity = 1]) {
    if (quantity < 1) return;
    _cart.update(
      p.id,
      (n) => (n + quantity).clamp(1, 99),
      ifAbsent: () => quantity.clamp(1, 99),
    );
    notifyListeners();
  }

  void changeQuantity(String id, int delta) {
    if (!_cart.containsKey(id)) return;
    final value = _cart[id]! + delta;
    if (value <= 0) {
      _cart.remove(id);
    } else {
      _cart[id] = value.clamp(1, 99);
    }
    notifyListeners();
  }

  void toggleWishlist(Product p) {
    if (!_wishlist.remove(p.id)) _wishlist.add(p.id);
    notifyListeners();
  }

  void resetFilters() {
    priceRange = const RangeValues(0, 5000);
    minRating = 0;
    filterColor = '';
    notifyListeners();
  }

  void signIn(String name, String mail) {
    username = name.trim().isEmpty ? 'Brandi Willz' : name.trim();
    if (mail.isNotEmpty) email = mail.trim();
    notifyListeners();
  }

  Order placeOrder() {
    if (_cart.isEmpty) throw StateError('Your cart is empty.');
    final order = Order(
      id: 'ML${_orders.length + 1001}',
      total: total,
      quantity: quantity,
      shipping: shippingNames[shipping],
      date: DateTime.now(),
    );
    _orders.insert(0, order);
    _cart.clear();
    shipping = 0;
    notifyListeners();
    return order;
  }
}

class ShopScope extends InheritedNotifier<ShopState> {
  const ShopScope({super.key, required ShopState state, required super.child})
    : super(notifier: state);
  static ShopState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShopScope>()!.notifier!;
}
