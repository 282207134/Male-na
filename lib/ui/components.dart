import 'package:flutter/material.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../models/product.dart';
import '../state/shop_state.dart';

Widget asset(
  String name, {
  BoxFit fit = BoxFit.contain,
  double? width,
  double? height,
  Alignment alignment = Alignment.center,
}) => Image.asset(
  'assets/images/$name.png',
  fit: fit,
  width: width,
  height: height,
  alignment: alignment,
  filterQuality: FilterQuality.medium,
);

class Brand extends StatelessWidget {
  const Brand({super.key, this.size = 28, this.color = Colors.white});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => Text(
    'Malèna',
    style: TextStyle(
      fontFamily: 'PlayfairDisplay',
      fontSize: size,
      color: color,
      letterSpacing: -1.5,
      height: 1.1,
    ),
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.light = false,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool light;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 48,
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: light ? Colors.white : ink,
        foregroundColor: light ? ink : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 12),
          ],
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.3,
            ),
          ),
        ],
      ),
    ),
  );
}

class ShopHeader extends StatelessWidget implements PreferredSizeWidget {
  const ShopHeader({
    super.key,
    this.title = '',
    this.dark = true,
    this.leadingBack = false,
    this.backLabel,
    this.actions = true,
    this.close = false,
    this.brand = false,
    this.overlay = false,
  });
  final String title;
  final bool dark, leadingBack, actions, close, brand, overlay;
  final String? backLabel;
  @override
  Size get preferredSize => const Size.fromHeight(72);
  @override
  Widget build(BuildContext context) {
    final state = ShopScope.of(context);
    final color = dark ? Colors.white : Theme.of(context).colorScheme.onSurface;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: overlay
          ? Colors.transparent
          : dark
          ? ink
          : Colors.transparent,
      foregroundColor: color,
      toolbarHeight: 72,
      leadingWidth: backLabel != null ? 110 : 62,
      leading: leadingBack
          ? TextButton(
              onPressed: () => back(context),
              style: TextButton.styleFrom(foregroundColor: color),
              child: Row(
                children: [
                  const Icon(Icons.chevron_left, size: 22),
                  if (backLabel != null)
                    Flexible(
                      child: Text(
                        backLabel!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            )
          : IconButton(
              key: const ValueKey('menu'),
              tooltip: 'Open menu',
              icon: const Icon(Icons.short_text, size: 28),
              onPressed: () => openPage(context, AppPage.menu),
            ),
      centerTitle: true,
      title: brand
          ? Brand(color: color)
          : Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
      actions: close
          ? [
              IconButton(
                tooltip: 'Close',
                onPressed: () => back(context),
                icon: const Icon(Icons.close),
              ),
            ]
          : actions
          ? [
              IconButton(
                key: const ValueKey('cart'),
                tooltip: 'Shopping cart',
                onPressed: () => openPage(context, AppPage.cart),
                icon: Badge(
                  isLabelVisible: state.quantity > 0,
                  backgroundColor: coral,
                  label: Text('${state.quantity}'),
                  child: const Icon(Icons.shopping_cart_outlined, size: 23),
                ),
              ),
              IconButton(
                tooltip: 'Search',
                onPressed: () => openPage(context, AppPage.search),
                icon: const Icon(Icons.search, size: 25),
              ),
              const SizedBox(width: 12),
            ]
          : null,
    );
  }
}

class BottomTabs extends StatelessWidget {
  const BottomTabs(this.selected, {super.key});
  final int selected;
  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.storefront_outlined,
      Icons.search,
      Icons.favorite_border,
      Icons.person_outline,
    ];
    const labels = ['Shop', 'Search', 'Wishlist', 'Account'];
    const pages = [
      AppPage.discover,
      AppPage.search,
      AppPage.wishlist,
      AppPage.account,
    ];
    return Container(
      color: mint,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: List.generate(
              4,
              (i) => Expanded(
                child: InkWell(
                  onTap: () => openPage(context, pages[i], clear: true),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[i],
                        color: selected == i ? Colors.white : ink,
                        size: 25,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 10,
                          color: selected == i ? Colors.white : ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.onTap});
  final String title;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            letterSpacing: -.6,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      if (onTap != null)
        TextButton(
          onPressed: onTap,
          child: const Text(
            'See all ›',
            style: TextStyle(
              color: ink,
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
    ],
  );
}

class ProductCard extends StatelessWidget {
  const ProductCard(this.product, {super.key});
  final Product product;
  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(5),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      key: ValueKey('product-${product.id}'),
      onTap: () => showProduct(context, product),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: const Color(0xfffcfcfc),
              padding: const EdgeInsets.all(18),
              width: double.infinity,
              child: asset(product.image),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 16, 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    letterSpacing: -.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.material}, ${product.category}'.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 8,
                    color: muted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Container(width: 17, height: 2, color: const Color(0xffdddddd)),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        money(product.price),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.circle, size: 7, color: coral),
                    const SizedBox(width: 5),
                    const Icon(Icons.circle, size: 7, color: ink),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void showProduct(BuildContext context, Product product) {
  ShopScope.of(context).selectedProduct = product;
  openPage(context, AppPage.product);
}

class ProductRow extends StatelessWidget {
  const ProductRow(this.product, {super.key, this.trailing, this.subtitle});
  final Product product;
  final Widget? trailing;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(4),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => showProduct(context, product),
      child: SizedBox(
        height: 132,
        child: Row(
          children: [
            Container(
              width: 118,
              color: const Color(0xfffcfcfc),
              padding: const EdgeInsets.all(17),
              child: asset(product.image),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle ??
                          '${product.category}, ${product.material}'
                              .toUpperCase(),
                      style: const TextStyle(
                        color: muted,
                        fontSize: 8,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            money(product.price),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ?trailing,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void toast(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.action,
    this.label = 'Browse more',
  });
  final String title, message, label;
  final IconData icon;
  final VoidCallback action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(30),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 40, color: muted),
        const SizedBox(height: 14),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: -.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: const TextStyle(fontSize: 13, color: muted, height: 1.6),
        ),
        const SizedBox(height: 24),
        SizedBox(width: 180, child: ActionButton(label, onPressed: action)),
      ],
    ),
  );
}
