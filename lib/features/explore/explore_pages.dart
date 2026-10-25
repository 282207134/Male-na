import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../state/shop_state.dart';
import '../../ui/components.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.results = false});
  final bool results;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controller.text.isEmpty && widget.results) {
      controller.text = ShopScope.of(context).query;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void search() {
    final value = controller.text.trim();
    if (value.isEmpty) return;
    final state = ShopScope.of(context);
    state.query = value;
    if (widget.results) {
      state.refresh();
    } else {
      openPage(context, AppPage.results);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ShopScope.of(context), items = state.searchResults;
    return Scaffold(
      backgroundColor: mint,
      bottomNavigationBar: const BottomTabs(1),
      appBar: AppBar(
        backgroundColor: ink,
        toolbarHeight: 72,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () => back(context),
              tooltip: 'Back',
              icon: const Icon(Icons.chevron_left, color: Colors.white),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                key: const ValueKey('search-input'),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => search(),
                decoration: const InputDecoration(
                  hintText: 'Search for an item',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 12),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Search',
              onPressed: search,
              icon: const Icon(Icons.search, color: Colors.white),
            ),
          ],
        ),
      ),
      body: widget.results
          ? items.isEmpty
                ? EmptyMessage(
                    title: 'No results for “${state.query}”',
                    message: 'Try “bag”, “leather”, “watch” or “beauty”.',
                    icon: Icons.search_off,
                    label: 'Search again',
                    action: () => back(context),
                  )
                : Container(
                    color: const Color(0xff333333),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => ProductRow(items[i]),
                    ),
                  )
          : Stack(
              fit: StackFit.expand,
              children: [
                asset('search_bg', fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.saved_search,
                        color: Colors.white,
                        size: 42,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Find the missing piece',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'A little something, just for you.\nFind your favourites in the collection.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final term in ['Leather', 'Bags', 'Watch'])
                            ActionChip(
                              backgroundColor: mint,
                              side: const BorderSide(color: Colors.white54),
                              label: Text(
                                term,
                                style: const TextStyle(
                                  color: ink,
                                  fontSize: 10,
                                ),
                              ),
                              onPressed: () {
                                controller.text = term;
                                search();
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = ShopScope.of(context), saved = state.wishlist.toList();
    return Scaffold(
      appBar: const ShopHeader(title: 'My Wishlist'),
      bottomNavigationBar: const BottomTabs(2),
      body: saved.isEmpty
          ? EmptyMessage(
              title: 'Save what you love',
              message: 'Tap the heart on a piece to keep it here.',
              icon: Icons.favorite_border,
              action: () => openPage(context, AppPage.discover, clear: true),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: saved.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final p = state.product(saved[i]);
                return ProductRow(
                  p,
                  trailing: InkResponse(
                    onTap: () => state.toggleWishlist(p),
                    child: const Icon(Icons.favorite, color: coral, size: 20),
                  ),
                );
              },
            ),
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const ShopHeader(title: 'Find us'),
    body: Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              asset('map', fit: BoxFit.cover),
              Positioned(
                right: 22,
                bottom: 22,
                child: CircleAvatar(
                  backgroundColor: coral,
                  child: IconButton(
                    tooltip: 'Store location',
                    color: Colors.white,
                    onPressed: () =>
                        toast(context, '1550 Jerome Avenue, Harlingen, Texas'),
                    icon: const Icon(Icons.location_on_outlined),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.all(28),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: asset(
                        'store',
                        width: 78,
                        height: 78,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 17),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '1550 Jerome Avenue\nHarlingen, Texas',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '2.1 MI     3.1/5  ★★★☆☆',
                            style: TextStyle(
                              fontSize: 9,
                              letterSpacing: 1,
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ActionButton(
                  'Get directions',
                  onPressed: () {
                    Clipboard.setData(
                      const ClipboardData(
                        text: '1550 Jerome Avenue, Harlingen, Texas',
                      ),
                    );
                    toast(
                      context,
                      'Store address copied. Open it in your maps app.',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        asset('scan', fit: BoxFit.cover),
        Container(color: Colors.black.withValues(alpha: .35)),
        SafeArea(
          child: Column(
            children: [
              const ShopHeader(
                title: 'Scan',
                leadingBack: true,
                backLabel: 'Back',
                actions: false,
                overlay: true,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Scan code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Discover the story behind your piece.\nTry a sample code in this demo.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.7,
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: SizedBox(
                          width: 245,
                          height: 245,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white70),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.qr_code_2,
                                size: 82,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      ActionButton(
                        'Scan sample code',
                        light: true,
                        key: const ValueKey('scan-sample'),
                        onPressed: () => showProduct(
                          context,
                          ShopScope.of(context).product('croc'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'DEMO PREVIEW',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 9,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
