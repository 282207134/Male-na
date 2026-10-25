import 'package:flutter/material.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../models/product.dart';
import '../../state/shop_state.dart';
import '../../ui/components.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final state = ShopScope.of(context);
    var items = state.filteredProducts;
    if (tab == 1) {
      items = items.where((p) => ['cream', 'black'].contains(p.id)).toList();
    }
    if (tab == 2) {
      items = items.where((p) => ['brown', 'croc'].contains(p.id)).toList();
    }
    return Scaffold(
      appBar: ShopHeader(
        title: state.category,
        dark: false,
        leadingBack: true,
        backLabel: 'Discover',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ink,
        foregroundColor: Colors.white,
        tooltip: 'Filters',
        key: const ValueKey('open-filters'),
        shape: const CircleBorder(),
        onPressed: () => openPage(context, AppPage.filters),
        child: const Icon(Icons.tune),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              itemCount: 3,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => SizedBox(
                width: 130,
                child: Material(
                  color: tab == i ? Colors.transparent : coral,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(color: coral, width: 1.5),
                  ),
                  child: InkWell(
                    onTap: () => setState(() => tab = i),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '0${i + 1}.',
                            style: TextStyle(
                              color: tab == i ? coral : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              height: 1.2,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            ['Leather', 'Backpacks', 'Handbags'][i],
                            style: TextStyle(
                              color: tab == i ? coral : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              height: 1.2,
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
          Expanded(
            child: items.isEmpty
                ? EmptyMessage(
                    title: 'No pieces found',
                    message: 'Try another category or clear your filters.',
                    icon: Icons.search_off,
                    label: 'Reset filters',
                    action: () {
                      state.resetFilters();
                      setState(() => tab = 0);
                    },
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 285,
                        ),
                    itemCount: items.length,
                    itemBuilder: (_, i) => ProductCard(items[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class FiltersPage extends StatelessWidget {
  const FiltersPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = ShopScope.of(context);
    return Scaffold(
      appBar: const ShopHeader(
        title: 'Filters',
        dark: false,
        leadingBack: true,
        close: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              TextButton(
                onPressed: state.resetFilters,
                child: const Text('Reset', style: TextStyle(color: muted)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ActionButton(
                  'Show ${state.filteredProducts.length} items',
                  key: const ValueKey('apply-filters'),
                  onPressed: () => back(context),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          panel(
            'Category',
            state.category,
            SizedBox(
              height: 95,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  const cats = [
                    'All',
                    'Bags',
                    'Wearables',
                    'Eyewear',
                    'Beauty',
                    'Jewellery',
                  ];
                  const icons = [
                    Icons.apps,
                    Icons.shopping_bag_outlined,
                    Icons.watch_outlined,
                    Icons.visibility_outlined,
                    Icons.spa_outlined,
                    Icons.diamond_outlined,
                  ];
                  return SizedBox(
                    width: 100,
                    child: Material(
                      color: state.category == cats[i] ? coral : sea,
                      borderRadius: BorderRadius.circular(4),
                      child: InkWell(
                        onTap: () {
                          state.category = cats[i];
                          state.refresh();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                icons[i],
                                color: state.category == cats[i]
                                    ? Colors.white
                                    : ink,
                              ),
                              const Spacer(),
                              Text(
                                cats[i],
                                style: const TextStyle(fontSize: 10),
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
          ),
          panel(
            'Colors',
            state.filterColor.isEmpty ? 'All colors' : state.filterColor,
            Wrap(
              spacing: 15,
              runSpacing: 14,
              children: [
                for (final (name, color) in [
                  ('All', Colors.white),
                  ('Cream', const Color(0xffd7c6ab)),
                  ('Brown', const Color(0xffb88457)),
                  ('Black', ink),
                ])
                  InkWell(
                    onTap: () {
                      state.filterColor = name == 'All' ? '' : name;
                      state.refresh();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: state.filterColor == name
                                  ? coral
                                  : Colors.black12,
                              width: 3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(name, style: const TextStyle(fontSize: 9)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          panel(
            'Pricing',
            '${money(state.priceRange.start)} – ${money(state.priceRange.end)}',
            Column(
              children: [
                RangeSlider(
                  values: state.priceRange,
                  min: 0,
                  max: 5000,
                  divisions: 50,
                  labels: RangeLabels(
                    money(state.priceRange.start),
                    money(state.priceRange.end),
                  ),
                  onChanged: (v) {
                    state.priceRange = v;
                    state.refresh();
                  },
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$0', style: TextStyle(fontSize: 10, color: muted)),
                    Text(
                      '\$5,000',
                      style: TextStyle(fontSize: 10, color: muted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          panel(
            'Reviews',
            state.minRating == 0
                ? 'All ratings'
                : '${state.minRating.toStringAsFixed(1)}+',
            Slider(
              value: state.minRating,
              min: 0,
              max: 5,
              divisions: 10,
              label: state.minRating.toStringAsFixed(1),
              onChanged: (v) {
                state.minRating = v;
                state.refresh();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget panel(String label, String value, Widget child) => Container(
    margin: const EdgeInsets.only(bottom: 2),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .35),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(value, style: const TextStyle(fontSize: 10)),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;
  String skin = 'Croc';
  @override
  Widget build(BuildContext context) {
    final state = ShopScope.of(context), p = state.selectedProduct;
    final saved = state.wishlist.contains(p.id);
    return Scaffold(
      body: CustomScrollView(
        key: const ValueKey('product-scroll'),
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 430,
                  color: const Color(0xffe0f3ef),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: p.id == 'croc'
                            ? asset('product_hero', fit: BoxFit.cover)
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  70,
                                  110,
                                  70,
                                  55,
                                ),
                                child: asset(p.image),
                              ),
                      ),
                      SafeArea(
                        bottom: false,
                        child: const ShopHeader(
                          dark: false,
                          leadingBack: true,
                          backLabel: 'All bags',
                        ),
                      ),
                      const Positioned(
                        left: 30,
                        bottom: 26,
                        child: Text(
                          '2  ━━━━━  6',
                          style: TextStyle(
                            fontSize: 10,
                            color: ink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 25,
                  bottom: -30,
                  child: SizedBox(
                    width: 62,
                    height: 62,
                    child: FloatingActionButton(
                      heroTag: 'favorite',
                      elevation: 0,
                      key: const ValueKey('product-favorite'),
                      tooltip: 'Toggle wishlist',
                      backgroundColor: coral,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      onPressed: () => state.toggleWishlist(p),
                      child: Icon(
                        saved ? Icons.favorite : Icons.favorite_border,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 34),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${p.category}, ${p.material}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    p.id == 'croc' ? 'Malèna Rose Croc\nLeather Bag' : p.name,
                    style: const TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    money(p.price, decimals: true),
                    style: const TextStyle(
                      color: muted,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(width: 24, height: 2, color: Colors.black12),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 24,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Skin',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          DropdownButton<String>(
                            value: skin,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                            ),
                            items: ['Croc', 'Smooth']
                                .map(
                                  (v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(v),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() => skin = v!),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Qty',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          DropdownButton<int>(
                            value: quantity,
                            items: List.generate(
                              5,
                              (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text('${i + 1}'),
                              ),
                            ),
                            onChanged: (v) => setState(() => quantity = v!),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ActionButton(
                    'Add to cart',
                    icon: Icons.add_shopping_cart,
                    key: const ValueKey('add-cart'),
                    onPressed: () {
                      state.add(p, quantity);
                      toast(context, 'Added to your bag.');
                    },
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () => state.toggleWishlist(p),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        saved ? 'REMOVE FROM WISHLIST' : '＋ ADD TO WISHLIST',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: ink,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: ink, thickness: 2),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(),
                child: Column(
                  children: [
                    ExpansionTile(
                      title: const Text(
                        'Specs',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      initiallyExpanded: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(22),
                          child: Wrap(
                            spacing: 38,
                            runSpacing: 28,
                            children: [
                              spec(
                                Icons.handyman_outlined,
                                'Materials',
                                p.material,
                              ),
                              spec(
                                Icons.square_foot_outlined,
                                'Size',
                                'W 25.7 × H 13.5 cm',
                              ),
                              spec(
                                Icons.umbrella_outlined,
                                'Extras',
                                'Water Resistance',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const ExpansionTile(
                      title: Text('Materials', style: TextStyle(fontSize: 13)),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(22),
                          child: Text(
                            'Carefully selected materials, made to last. Wipe gently with a soft dry cloth.',
                            style: TextStyle(fontSize: 12, height: 1.7),
                          ),
                        ),
                      ],
                    ),
                    const ExpansionTile(
                      title: Text(
                        'Shipping & Returns',
                        style: TextStyle(fontSize: 13),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(22),
                          child: Text(
                            'Complimentary regular delivery. Return unworn pieces within 30 days.',
                            style: TextStyle(fontSize: 12, height: 1.7),
                          ),
                        ),
                      ],
                    ),
                    ListTile(
                      title: const Text(
                        'Reviews',
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: Text('★ ${p.rating}  ›'),
                      onTap: () => openPage(context, AppPage.reviews),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget spec(IconData icon, String label, String value) => SizedBox(
    width: 125,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: muted, size: 28),
        const SizedBox(height: 22),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 9,
            color: muted,
            letterSpacing: 1,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const ShopHeader(
      title: 'Reviews',
      dark: false,
      leadingBack: true,
      close: true,
    ),
    body: ListView.separated(
      itemCount: 4,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 21,
              backgroundColor: const Color(0xffbdbdbd),
              child: Text(
                ['S', 'B', 'V', 'A'][i],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          [
                            'Sarah Montegre',
                            'Bradley James Jr',
                            'Vanessa Muller',
                            'Amy Jones',
                          ][i],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Text(
                        '11 OCT',
                        style: TextStyle(fontSize: 8, color: muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    i == 0 ? '★★★☆☆' : '★★★★☆',
                    style: const TextStyle(fontSize: 13, letterSpacing: 2),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    [
                      'Simply amazing!',
                      'Beautiful everyday piece',
                      'It’s really cool',
                      'Worth the wait',
                    ][i],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Lovely details and a beautiful finish. The leather feels soft and the size is perfect for everyday.',
                    style: TextStyle(fontSize: 11, color: muted, height: 1.7),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
