import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../models/product.dart';
import '../../state/shop_state.dart';
import '../../ui/components.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, this.forceEmpty = false});
  final bool forceEmpty;
  @override
  Widget build(BuildContext context) {
    final state = ShopScope.of(context);
    final empty = forceEmpty || state.cart.isEmpty;
    return Scaffold(
      appBar: ShopHeader(title: 'My Cart (${empty ? 0 : state.cart.length})'),
      body: empty
          ? EmptyMessage(
              title: 'Empty Cart',
              icon: Icons.sentiment_dissatisfied_outlined,
              message:
                  'Your next favourite piece is waiting.\nExplore the collection and make it yours.',
              action: () => openPage(context, AppPage.discover, clear: true),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.cart.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final entry = state.cart.entries.elementAt(i),
                          p = state.product(entry.key);
                      return SizedBox(
                        height: 140,
                        child: Material(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(5),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => showProduct(context, p),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: asset(
                                    p.image,
                                    width: 105,
                                    height: 105,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    6,
                                    18,
                                    12,
                                    14,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'BAGS, LEATHER',
                                        style: TextStyle(
                                          fontSize: 8,
                                          letterSpacing: 1,
                                          color: muted,
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              money(p.price * entry.value),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          QuantityControl(
                                            value: entry.value,
                                            onMinus: () =>
                                                state.changeQuantity(p.id, -1),
                                            onPlus: () =>
                                                state.changeQuantity(p.id, 1),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          key: ValueKey('remove-${p.id}'),
                                          onTap: () => state.changeQuantity(
                                            p.id,
                                            -entry.value,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Text(
                                              'Remove',
                                              style: TextStyle(
                                                fontSize: 9,
                                                color: muted,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 12, 30, 22),
                  child: Column(
                    children: [
                      const OrderSummary(),
                      const SizedBox(height: 20),
                      ActionButton(
                        'Proceed to checkout',
                        key: const ValueKey('checkout'),
                        onPressed: () => openPage(context, AppPage.shipping),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class QuantityControl extends StatelessWidget {
  const QuantityControl({
    super.key,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });
  final int value;
  final VoidCallback onMinus, onPlus;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      InkResponse(
        onTap: onMinus,
        radius: 18,
        child: const Icon(Icons.remove_circle_outline, size: 24, color: muted),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Text('$value', style: const TextStyle(fontSize: 13)),
      ),
      InkResponse(
        onTap: onPlus,
        radius: 18,
        child: const Icon(Icons.add_circle, size: 24, color: coral),
      ),
    ],
  );
}

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});
  @override
  Widget build(BuildContext context) {
    final state = ShopScope.of(context);
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 10),
        for (final entry in [
          ('SUBTOTAL', money(state.subtotal)),
          ('TAX', '\$0'),
          (
            'SHIPPING',
            state.shippingPrice == 0 ? 'Free' : money(state.shippingPrice),
          ),
          ('TOTAL', money(state.total)),
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    entry.$1,
                    style: TextStyle(
                      color: entry.$1 == 'TOTAL' ? null : muted,
                      fontSize: 9,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  entry.$2,
                  style: TextStyle(
                    fontSize: entry.$1 == 'TOTAL' ? 15 : 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ShippingPage extends StatelessWidget {
  const ShippingPage({super.key});
  Future<void> editAddress(BuildContext context, ShopState state) async {
    final controller = TextEditingController(text: state.address);
    final result = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delivery address'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Street, city, postal code',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(c, controller.text.trim());
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      state.address = result;
      state.refresh();
    }
    // The route transition still uses the controller until the dialog is disposed.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ShopScope.of(context);
    return Scaffold(
      appBar: const ShopHeader(
        title: 'Shipping',
        leadingBack: true,
        backLabel: 'Back',
        actions: false,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ActionButton(
            'Proceed to payment',
            key: const ValueKey('to-payment'),
            onPressed: state.cart.isEmpty
                ? null
                : () => openPage(context, AppPage.payment),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(25, 22, 25, 30),
        children: [
          const Text(
            'When would you like\nto receive your item',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              letterSpacing: -.8,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 42),
          Text(
            'DELIVER TO',
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 9,
              letterSpacing: 1.3,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              state.address,
              style: const TextStyle(fontSize: 12, height: 1.6),
            ),
            trailing: const Icon(Icons.edit_outlined, size: 19),
            onTap: () => editAddress(context, state),
          ),
          const SizedBox(height: 35),
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            child: Column(
              children: List.generate(
                3,
                (i) => Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 16,
                      ),
                      key: ValueKey('shipping-$i'),
                      onTap: () {
                        state.shipping = i;
                        state.refresh();
                      },
                      leading: CircleAvatar(
                        backgroundColor: coral,
                        foregroundColor: Colors.white,
                        child: Icon(
                          [
                            Icons.local_post_office_outlined,
                            Icons.local_shipping_outlined,
                            Icons.rocket_launch_outlined,
                          ][i],
                          size: 22,
                        ),
                      ),
                      title: Text(
                        ShopState.shippingNames[i],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          [
                            'Estimated 13–16 Days',
                            'Estimated 3–6 Days',
                            'Estimated 1–2 Days',
                          ][i],
                          style: const TextStyle(fontSize: 10, color: muted),
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            i == 0
                                ? 'Free'
                                : '+${money(ShopState.shippingPrices[i])}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Icon(
                            state.shipping == i
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: state.shipping == i ? mint : muted,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    if (i < 2)
                      const Divider(indent: 75, endIndent: 15, height: 1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final card = TextEditingController();
  final expiry = TextEditingController();
  final cvc = TextEditingController();
  int method = 0;
  bool submitting = false;
  @override
  void dispose() {
    for (final c in [name, card, expiry, cvc]) {
      c.dispose();
    }
    super.dispose();
  }

  void fillDemo() => setState(() {
    name.text = 'Brandi Willz';
    card.text = '4242 4242 4242 4242';
    expiry.text = '12/30';
    cvc.text = '123';
  });
  void submit() {
    if (submitting || !(form.currentState?.validate() ?? false)) return;
    final state = ShopScope.of(context);
    if (state.cart.isEmpty) {
      toast(context, 'Your cart is empty.');
      return;
    }
    setState(() => submitting = true);
    state.placeOrder();
    openPage(context, AppPage.done, clear: true);
  }

  Widget input(
    String label,
    TextEditingController controller, {
    bool digits = false,
    String? Function(String)? check,
  }) => TextFormField(
    controller: controller,
    key: ValueKey('payment-$label'),
    keyboardType: digits ? TextInputType.number : TextInputType.text,
    inputFormatters: digits
        ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9 /]'))]
        : null,
    style: const TextStyle(fontSize: 13),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 12),
    ),
    validator: (v) =>
        v == null || v.trim().isEmpty ? 'Required' : check?.call(v),
  );
  @override
  Widget build(BuildContext context) {
    final state = ShopScope.of(context);
    return Scaffold(
      appBar: const ShopHeader(
        title: 'Payment Details',
        leadingBack: true,
        backLabel: 'Back',
        actions: false,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 5, 25, 20),
          child: ActionButton(
            'Finish demo purchase',
            key: const ValueKey('finish-purchase'),
            onPressed: state.cart.isEmpty || submitting ? null : submit,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            color: ink,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: Row(
              children: List.generate(
                3,
                (i) => Expanded(
                  child: InkWell(
                    onTap: () => setState(() => method = i),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: method == i
                              ? coral
                              : const Color(0xff555555),
                          child: Icon(
                            [
                              Icons.credit_card_outlined,
                              Icons.paypal,
                              Icons.apple,
                            ][i],
                            color: Colors.white,
                            size: 23,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          ['Credit Card', 'PayPal', 'Apple Pay'][i],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 24, 25, 18),
            child: Form(
              key: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fill in your info',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -.7,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (method == 0) ...[
                    input('Cardholder name', name),
                    input(
                      'Card number',
                      card,
                      digits: true,
                      check: (v) => v.replaceAll(' ', '').length != 16
                          ? 'Enter 16 digits'
                          : null,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: input(
                            'MM/YY',
                            expiry,
                            digits: true,
                            check: (v) {
                              final match = RegExp(
                                r'^(0[1-9]|1[0-2])/(\d{2})$',
                              ).firstMatch(v);
                              if (match == null) return 'Use MM/YY';
                              final end = DateTime(
                                2000 + int.parse(match[2]!),
                                int.parse(match[1]!) + 1,
                              );
                              return end.isBefore(DateTime.now())
                                  ? 'Card has expired'
                                  : null;
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: input(
                            'CVC',
                            cvc,
                            digits: true,
                            check: (v) => !RegExp(r'^\d{3,4}$').hasMatch(v)
                                ? 'Use 3–4 digits'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        key: const ValueKey('use-demo-card'),
                        onPressed: fillDemo,
                        child: const Text(
                          'Use demo card',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 20),
                    Text(
                      '${['Credit Card', 'PayPal', 'Apple Pay'][method]} is simulated in this demo.',
                      style: const TextStyle(fontSize: 13, height: 1.7),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const Text(
                    'Demo only. Use the sample card; no real payment is collected.',
                    style: TextStyle(fontSize: 10, color: muted, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'In Order',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -.7,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${state.cart.length} items in total, Qty: ${state.quantity}\n'
                  '${ShopState.shippingNames[state.shipping]} delivery\n${state.address}',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 11,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(25, 10, 25, 20),
            child: OrderSummary(),
          ),
        ],
      ),
    );
  }
}

class DonePage extends StatelessWidget {
  const DonePage({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = ShopScope.of(context).orders;
    return Scaffold(
      appBar: const ShopHeader(title: 'My Account'),
      body: Stack(
        fit: StackFit.expand,
        children: [
          asset('done_bg', fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 39),
                ),
                const SizedBox(height: 35),
                const Text(
                  'Order sent!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  orders.isEmpty
                      ? 'Your beautiful pieces are on their way.'
                      : 'Order ${orders.first.id} · ${money(orders.first.total)}\nYour demo order is ready to view in your account.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: 200,
                  child: ActionButton(
                    'Browse more',
                    key: const ValueKey('browse-after-order'),
                    onPressed: () =>
                        openPage(context, AppPage.discover, clear: true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
