import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:malena/app.dart';
import 'package:malena/core/routes.dart';
import 'package:malena/data/catalog.dart';
import 'package:malena/state/shop_state.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('22 screens and a complete shopping journey', (tester) async {
    final state = ShopState();
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MalenaApp(state: state, navigatorKey: navigator));
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();

    Future<void> capture(String name) async {
      await tester.pumpAndSettle();
      await Future<void>.delayed(const Duration(milliseconds: 250));
      final bytes = await binding.takeScreenshot(name);
      final directory = Directory(
        '${Directory.systemTemp.path}/malena-screenshots',
      );
      await directory.create(recursive: true);
      await File('${directory.path}/$name.png').writeAsBytes(bytes);
      // Keep large image arrays out of the VM service response.
      binding.reportData!.remove('screenshots');
      final names =
          binding.reportData!.putIfAbsent('captureFiles', () => <String>[])
              as List<String>;
      names.add('$name.png');
      expect(tester.takeException(), isNull, reason: name);
    }

    Future<void> show(AppPage page) async {
      navigator.currentState!.pushNamedAndRemoveUntil(
        '/${page.name}',
        (_) => false,
      );
      await tester.pumpAndSettle();
    }

    Future<void> tapKey(String key) async {
      final finder = find.byKey(ValueKey(key));
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    await capture('01-splash');
    await tapKey('start-login');
    await capture('02-login');
    await tester.enterText(
      find.byKey(const ValueKey('USERNAME')),
      'Brandi Willz',
    );
    await tester.enterText(find.byKey(const ValueKey('PASSWORD')), 'demo123');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tapKey('auth-submit');
    expect(find.byKey(const ValueKey('page-editorial')), findsOneWidget);
    await capture('04-editorial');
    await tapKey('shop-now');
    await capture('05-discover');
    await tester.drag(
      find.byKey(const ValueKey('discover-scroll')),
      const Offset(0, -550),
    );
    await capture('05b-discover-collections');
    await tester.drag(
      find.byKey(const ValueKey('discover-scroll')),
      const Offset(0, -650),
    );
    await capture('05c-discover-newsletter');

    await show(AppPage.category);
    await capture('07-category');
    await tapKey('open-filters');
    await capture('08-filters');
    await tapKey('apply-filters');
    await tapKey('product-croc');
    await capture('09-product');
    await tester.drag(
      find.byKey(const ValueKey('product-scroll')),
      const Offset(0, -510),
    );
    await capture('09b-product-details');
    await tapKey('add-cart');
    expect(state.quantity, 1);
    state.add(products[1], 2);
    await show(AppPage.cart);
    await capture('12-cart');
    expect(state.subtotal, 7770);
    await tapKey('checkout');
    await capture('13-shipping');
    await tapKey('shipping-1');
    expect(state.total, 7795);
    await tapKey('to-payment');
    await capture('14-payment');
    await tapKey('use-demo-card');
    await tapKey('finish-purchase');
    expect(state.orders.single.total, 7795);
    expect(state.cart, isEmpty);
    await capture('15-done');

    await show(AppPage.signup);
    await capture('03-signup');
    await show(AppPage.menu);
    await capture('06-menu');
    await show(AppPage.reviews);
    await capture('10-reviews');
    await show(AppPage.cart);
    await capture('11-cart-empty');
    await show(AppPage.search);
    await capture('16-search');
    await tester.enterText(
      find.byKey(const ValueKey('search-input')),
      'Leather',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('page-results')), findsOneWidget);
    await capture('17-search-results');
    await show(AppPage.wishlist);
    await capture('18-wishlist');
    await show(AppPage.map);
    await capture('19-map');
    await show(AppPage.scan);
    await capture('20-scan');
    await tapKey('scan-sample');
    expect(find.byKey(const ValueKey('page-product')), findsOneWidget);
    await show(AppPage.account);
    await capture('21-account');
    await show(AppPage.settings);
    await capture('22-settings');
    await tester.tap(find.text('Dark Mode'));
    await tester.pumpAndSettle();
    expect(state.darkMode, isTrue);
    await capture('22b-settings-dark');
    await tester.tap(find.text('Dark Mode'));
    await tester.pumpAndSettle();
    await show(AppPage.discover);
  });
}
