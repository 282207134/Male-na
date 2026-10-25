import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/routes.dart';
import 'core/theme.dart';
import 'features/account/account_pages.dart';
import 'features/auth/auth_pages.dart';
import 'features/checkout/checkout_pages.dart';
import 'features/explore/explore_pages.dart';
import 'features/shop/catalog_pages.dart';
import 'features/shop/discover_page.dart';
import 'state/shop_state.dart';

class MalenaApp extends StatefulWidget {
  const MalenaApp({
    super.key,
    this.state,
    this.navigatorKey,
    this.initialPage = AppPage.splash,
  });
  final ShopState? state;
  final GlobalKey<NavigatorState>? navigatorKey;
  final AppPage initialPage;
  @override
  State<MalenaApp> createState() => _MalenaAppState();
}

class _MalenaAppState extends State<MalenaApp> {
  late final ShopState state = widget.state ?? ShopState();
  @override
  void dispose() {
    if (widget.state == null) state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShopScope(
    state: state,
    child: ListenableBuilder(
      listenable: state,
      builder: (_, _) => MaterialApp(
        title: 'Malèna',
        debugShowCheckedModeBanner: false,
        theme: appTheme(state.darkMode),
        navigatorKey: widget.navigatorKey,
        initialRoute: '/${widget.initialPage.name}',
        onGenerateInitialRoutes: (route) => [
          routeFor(RouteSettings(name: route)),
        ],
        onGenerateRoute: routeFor,
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: state.darkMode
                ? Brightness.light
                : Brightness.dark,
            systemNavigationBarColor: state.darkMode ? ink : paper,
            systemNavigationBarIconBrightness: state.darkMode
                ? Brightness.light
                : Brightness.dark,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: child!,
            ),
          ),
        ),
      ),
    ),
  );
  Route<dynamic> routeFor(RouteSettings settings) {
    final page = AppPage.values.firstWhere(
      (p) => '/${p.name}' == settings.name,
      orElse: () => AppPage.discover,
    );
    final Widget screen = switch (page) {
      AppPage.splash => const SplashPage(),
      AppPage.login => const AuthPage(),
      AppPage.signup => const AuthPage(signUp: true),
      AppPage.editorial => const EditorialPage(),
      AppPage.discover => const DiscoverPage(),
      AppPage.menu => const MenuPage(),
      AppPage.category => const CategoryPage(),
      AppPage.filters => const FiltersPage(),
      AppPage.product => const ProductPage(),
      AppPage.reviews => const ReviewsPage(),
      AppPage.emptyCart => const CartPage(forceEmpty: true),
      AppPage.cart => const CartPage(),
      AppPage.shipping => const ShippingPage(),
      AppPage.payment => const PaymentPage(),
      AppPage.done => const DonePage(),
      AppPage.search => const SearchPage(),
      AppPage.results => const SearchPage(results: true),
      AppPage.wishlist => const WishlistPage(),
      AppPage.map => const MapPage(),
      AppPage.scan => const ScanPage(),
      AppPage.account => const AccountPage(),
      AppPage.settings => const SettingsPage(),
    };
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) =>
          KeyedSubtree(key: ValueKey('page-${page.name}'), child: screen),
    );
  }
}
