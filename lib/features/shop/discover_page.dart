import 'package:flutter/material.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../state/shop_state.dart';
import '../../ui/components.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});
  void category(BuildContext context, String value) {
    ShopScope.of(context).category = value;
    openPage(context, AppPage.category);
  }

  Widget collection(
    BuildContext context,
    String name,
    String image, {
    double height = 105,
    bool horizontal = false,
  }) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(5),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => category(context, name),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: horizontal ? null : 40,
              width: horizontal ? 125 : null,
              left: horizontal ? null : 0,
              child: asset(
                image,
                fit: BoxFit.contain,
                height: horizontal ? 160 : null,
              ),
            ),
            Positioned(
              left: 23,
              bottom: horizontal ? 20 : 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: ink,
                      letterSpacing: -.7,
                    ),
                  ),
                  const Text(
                    '32 ITEMS',
                    style: TextStyle(
                      color: muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const ShopHeader(brand: true),
    body: ListView(
      key: const ValueKey('discover-scroll'),
      children: [
        Stack(
          children: [
            Positioned(
              top: 18,
              right: 0,
              bottom: 0,
              left: 137,
              child: Container(color: sea),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 22, 24, 20),
                  child: SectionHeading(
                    'New Arrivals',
                    onTap: () => category(context, 'Bags'),
                  ),
                ),
                SizedBox(
                  height: 292,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (_, _) => const SizedBox(width: 15),
                    itemBuilder: (_, i) =>
                        SizedBox(width: 188, child: ProductCard(products[i])),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 44),
          child: Column(
            children: [
              collection(context, 'Wearables', 'watch', horizontal: true),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: collection(
                      context,
                      'Eyewear',
                      'eyewear',
                      height: 236,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: collection(
                      context,
                      'Bags',
                      'bag_category',
                      height: 236,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              collection(
                context,
                'Beauty',
                'beauty',
                height: 86,
                horizontal: true,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SectionHeading(
            'Top Categories',
            onTap: () => category(context, 'All'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 106,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            itemCount: 4,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              const names = ['Beauty', 'Bags', 'Wearables', 'Jewellery'];
              const icons = [
                Icons.spa_outlined,
                Icons.shopping_bag_outlined,
                Icons.watch_outlined,
                Icons.diamond_outlined,
              ];
              return SizedBox(
                width: 143,
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  child: InkWell(
                    onTap: () => category(context, names[i]),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icons[i], color: ink, size: 31),
                          const Spacer(),
                          Text(
                            names[i],
                            style: const TextStyle(
                              color: ink,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 48),
        const NewsletterPanel(),
      ],
    ),
  );
}

class NewsletterPanel extends StatefulWidget {
  const NewsletterPanel({super.key});
  @override
  State<NewsletterPanel> createState() => _NewsletterPanelState();
}

class _NewsletterPanelState extends State<NewsletterPanel> {
  final email = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    color: coral,
    padding: const EdgeInsets.fromLTRB(30, 34, 25, 35),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WEEKLY NEWSLETTER',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Get -10% week offer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Type your email'),
              ),
            ),
            IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: ink),
              onPressed: () {
                if (!RegExp(
                  r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                ).hasMatch(email.text)) {
                  toast(context, 'Enter a valid email address.');
                  return;
                }
                ShopScope.of(context)
                  ..newsletter = true
                  ..refresh();
                toast(context, 'You’re on the demo list. Use code MALENA10.');
              },
              icon: const Icon(Icons.send_outlined, size: 19),
            ),
          ],
        ),
      ],
    ),
  );
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: mint,
    body: Stack(
      children: [
        Positioned(
          left: -130,
          right: 30,
          bottom: -260,
          child: Opacity(
            opacity: .65,
            child: asset('splash', height: 600, fit: BoxFit.cover),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 16, 30, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    tooltip: 'Close menu',
                    color: Colors.white,
                    onPressed: () => back(context),
                    icon: const Icon(Icons.close),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      menuItem(context, 'Discover', AppPage.discover),
                      menuItem(context, 'Shop', AppPage.category),
                      for (final name in [
                        'Originals',
                        'Wearables',
                        'Bags',
                        'Eyewear',
                        'Beauty',
                      ])
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: menuItem(
                            context,
                            name,
                            AppPage.category,
                            small: true,
                            category: name,
                          ),
                        ),
                      const SizedBox(height: 22),
                      menuItem(context, 'Gallery', AppPage.editorial),
                      menuItem(context, 'Scan', AppPage.scan),
                      menuItem(context, 'Find us', AppPage.map),
                      menuItem(context, 'My account', AppPage.account),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => openPage(context, AppPage.settings),
                  child: const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
  Widget menuItem(
    BuildContext context,
    String label,
    AppPage page, {
    bool small = false,
    String? category,
  }) => InkWell(
    onTap: () {
      if (page == AppPage.category) {
        ShopScope.of(context).category = category == 'Originals'
            ? 'All'
            : category ?? 'Bags';
      }
      openPage(context, page, clear: page == AppPage.discover);
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: small ? 8 : 7),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: small ? 20 : 29,
          fontWeight: FontWeight.w600,
          letterSpacing: -.8,
        ),
      ),
    ),
  );
}
