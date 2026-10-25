import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:malena/app.dart';
import 'package:malena/core/routes.dart';

void main() {
  testWidgets('login validates required fields before entering the shop', (
    tester,
  ) async {
    await tester.pumpWidget(const MalenaApp(initialPage: AppPage.login));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('auth-submit')));
    await tester.tap(find.byKey(const ValueKey('auth-submit')));
    await tester.pumpAndSettle();
    expect(find.text('This field is required'), findsNWidgets(2));
    await tester.enterText(find.byKey(const ValueKey('USERNAME')), 'Brandi');
    await tester.enterText(find.byKey(const ValueKey('PASSWORD')), 'demo123');
    await tester.ensureVisible(find.byKey(const ValueKey('auth-submit')));
    await tester.tap(find.byKey(const ValueKey('auth-submit')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('page-editorial')), findsOneWidget);
  });
}
