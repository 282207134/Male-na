import 'package:flutter/material.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../models/product.dart';
import '../../state/shop_state.dart';
import '../../ui/components.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  void details(BuildContext context, String title, Widget content) =>
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (c) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                content,
              ],
            ),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    final state = ShopScope.of(context);
    const labels = [
      'Pending orders',
      'Promotions',
      'Cards',
      'History',
      'Subscription',
    ];
    const icons = [
      Icons.schedule,
      Icons.local_offer_outlined,
      Icons.credit_card,
      Icons.history,
      Icons.mail_outline,
    ];
    return Scaffold(
      appBar: const ShopHeader(title: 'My Account'),
      bottomNavigationBar: const BottomTabs(3),
      body: ListView(
        children: [
          SizedBox(
            height: 265,
            child: Stack(
              fit: StackFit.expand,
              children: [
                asset('profile', fit: BoxFit.cover),
                Container(color: Colors.black.withValues(alpha: .78)),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipOval(
                            child: asset(
                              'avatar',
                              width: 76,
                              height: 76,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: -5,
                            bottom: -4,
                            child: CircleAvatar(
                              radius: 17,
                              backgroundColor: coral,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                  size: 17,
                                ),
                                tooltip: 'Edit account',
                                onPressed: () =>
                                    openPage(context, AppPage.settings),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        state.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -.8,
                        ),
                      ),
                      Text(
                        '@${state.username.toLowerCase().replaceAll(' ', '')}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(width: 18, height: 2, color: Colors.white54),
                    ],
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < labels.length; i++)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 3,
              ),
              leading: Icon(icons[i], size: 22, color: muted),
              title: Text(
                labels[i],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, size: 19, color: muted),
              onTap: () {
                if (i == 0 || i == 3) {
                  details(
                    context,
                    labels[i],
                    state.orders.isEmpty
                        ? const Text(
                            'No orders yet. Your demo orders will appear here.',
                            style: TextStyle(
                              fontSize: 13,
                              color: muted,
                              height: 1.7,
                            ),
                          )
                        : ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 350),
                            child: ListView(
                              shrinkWrap: true,
                              children: state.orders
                                  .map(
                                    (order) => ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        order.id,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${order.quantity} pieces · ${order.shipping}\n'
                                        '${order.date.year}-${order.date.month}-${order.date.day}',
                                      ),
                                      trailing: Text(money(order.total)),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                  );
                } else if (i == 1) {
                  details(
                    context,
                    'A little treat',
                    const Text(
                      'MALENA10\n10% off your next collection.\n'
                      'This promotional code is for demonstration.',
                      style: TextStyle(fontSize: 16, height: 1.8),
                    ),
                  );
                } else if (i == 2) {
                  details(
                    context,
                    'Cards',
                    const Text(
                      'No cards stored.\nUse the demo card during checkout.',
                      style: TextStyle(fontSize: 13, height: 1.8),
                    ),
                  );
                } else {
                  openPage(context, AppPage.settings);
                }
              },
            ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            leading: const Icon(
              Icons.settings_outlined,
              size: 22,
              color: muted,
            ),
            title: const Text(
              'Settings',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.chevron_right, size: 19, color: muted),
            onTap: () => openPage(context, AppPage.settings),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int tab = 0;
  final form = GlobalKey<FormState>();
  late final TextEditingController name, email;
  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final state = ShopScope.of(context);
      name = TextEditingController(text: state.username);
      email = TextEditingController(text: state.email);
      initialized = true;
    }
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ShopScope.of(context);
    return Scaffold(
      appBar: const ShopHeader(
        title: 'Settings',
        leadingBack: true,
        backLabel: 'Back',
        actions: false,
      ),
      body: Column(
        children: [
          Container(
            color: ink,
            child: Row(
              children: [
                for (var i = 0; i < 2; i++)
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => tab = i),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: tab == i ? mint : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          ['General', 'Account'][i],
                          style: TextStyle(
                            color: tab == i ? Colors.white : muted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                if (tab == 0) ...[
                  ListTile(
                    title: const Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'USERNAME, EMAIL',
                      style: TextStyle(
                        color: muted,
                        fontSize: 8,
                        letterSpacing: 1.2,
                      ),
                    ),
                    onTap: () => setState(() => tab = 1),
                  ),
                  setting('Push Notifications', state.notifications, (v) {
                    state.notifications = v;
                    state.refresh();
                  }),
                  setting('Dark Mode', state.darkMode, (v) {
                    state.darkMode = v;
                    state.refresh();
                  }),
                  setting('Weekly Subscription', state.newsletter, (v) {
                    state.newsletter = v;
                    state.refresh();
                  }),
                  ListTile(
                    title: const Text(
                      'About Malèna',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'LOCAL SHOPPING DEMO',
                      style: TextStyle(
                        color: muted,
                        fontSize: 8,
                        letterSpacing: 1.2,
                      ),
                    ),
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: 'Malèna',
                      applicationVersion: '1.0.0',
                      children: [
                        const Text(
                          'Based on the Malèna Pixso UI. All shopping, payment, scanning and notification flows are local demonstrations.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Version 1.0.0\nMade with care',
                      style: TextStyle(fontSize: 13, color: muted, height: 1.8),
                    ),
                  ),
                ] else
                  Form(
                    key: form,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: name,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                            ),
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Enter your name'
                                : null,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: (v) =>
                                v == null ||
                                    !RegExp(
                                      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                    ).hasMatch(v)
                                ? 'Enter a valid email'
                                : null,
                          ),
                          const SizedBox(height: 30),
                          ActionButton(
                            'Save changes',
                            onPressed: () {
                              if (form.currentState!.validate()) {
                                state.signIn(name.text, email.text);
                                toast(
                                  context,
                                  'Account updated for this session.',
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () =>
                                openPage(context, AppPage.splash, clear: true),
                            child: const Text(
                              'Back to welcome',
                              style: TextStyle(color: muted),
                            ),
                          ),
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

  Widget setting(String label, bool value, ValueChanged<bool> onChanged) =>
      SwitchListTile(
        title: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          value ? 'ENABLED' : 'DISABLED',
          style: const TextStyle(color: muted, fontSize: 8, letterSpacing: 1.2),
        ),
        value: value,
        onChanged: onChanged,
      );
}
