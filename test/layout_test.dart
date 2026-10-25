import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:malena/app.dart';
import 'package:malena/core/routes.dart';
import 'package:malena/data/catalog.dart';
import 'package:malena/state/shop_state.dart';

void main() {
  testWidgets('every route fits a compact phone without layout exceptions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final state = ShopState()
      ..add(products[2])
      ..query = 'leather';
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MalenaApp(state: state, navigatorKey: navigator));
    for (final page in AppPage.values) {
      navigator.currentState!.pushNamedAndRemoveUntil(
        '/${page.name}',
        (_) => false,
      );
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey('page-${page.name}')), findsOneWidget);
      expect(tester.takeException(), isNull, reason: page.name);
    }
    await tester.pumpWidget(const SizedBox());
    state.dispose();
  });
}
