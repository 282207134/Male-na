import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:malena/data/catalog.dart';
import 'package:malena/state/shop_state.dart';

void main() {
  late ShopState state;
  setUp(() => state = ShopState());
  tearDown(() => state.dispose());
  test('cart quantities, shipping and totals stay consistent', () {
    state.add(products[2]);
    state.add(products[1], 2);
    expect(state.quantity, 3);
    expect(state.subtotal, 7770);
    state.shipping = 1;
    expect(state.total, 7795);
    state.changeQuantity('cream', -1);
    expect(state.subtotal, 5380);
    state.changeQuantity('croc', -1);
    expect(state.cart.keys, ['cream']);
    state.changeQuantity('cream', -1);
    expect(state.cart, isEmpty);
  });
  test(
    'order snapshots totals before cart reset and rejects empty checkout',
    () {
      expect(state.placeOrder, throwsStateError);
      state.add(products[2], 2);
      state.shipping = 2;
      final order = state.placeOrder();
      expect(order.total, 6080);
      expect(order.quantity, 2);
      expect(order.shipping, 'Ultra Fast');
      expect(state.cart, isEmpty);
      expect(state.shipping, 0);
      expect(state.orders.single.id, 'ML1001');
    },
  );
  test('search and filters use catalog data', () {
    state.query = '  LEATHER  ';
    expect(state.searchResults.length, 4);
    state.priceRange = const RangeValues(2000, 3000);
    expect(state.filteredProducts.map((p) => p.id), ['cream', 'croc']);
    state.filterColor = 'Brown';
    expect(state.filteredProducts.single.id, 'croc');
    state.minRating = 5;
    expect(state.filteredProducts, isEmpty);
    state.resetFilters();
    expect(state.filteredProducts.length, 4);
  });
  test('wishlist toggles and cart exposes immutable views', () {
    state.toggleWishlist(products[2]);
    expect(state.wishlist, contains('croc'));
    state.toggleWishlist(products[2]);
    expect(state.wishlist, isNot(contains('croc')));
    expect(() => state.cart['brown'] = 20, throwsUnsupportedError);
    state.add(products[0], 200);
    expect(state.quantity, 99);
  });
}
