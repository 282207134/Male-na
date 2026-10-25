import 'package:flutter/material.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../state/shop_state.dart';
import '../../ui/components.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        asset('splash', fit: BoxFit.cover),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                const SizedBox(height: 40),
                CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: asset('logo'),
                  ),
                ),
                const SizedBox(height: 13),
                const Brand(size: 48),
                const Spacer(flex: 2),
                const Text(
                  'MADE IN ITALY',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 3,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Quality is not an act\nIt’s a natural habit.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -.8,
                  ),
                ),
                const Spacer(flex: 3),
                ActionButton(
                  'Sign up',
                  key: const ValueKey('start-signup'),
                  light: true,
                  onPressed: () => openPage(context, AppPage.signup),
                ),
                TextButton(
                  key: const ValueKey('start-login'),
                  onPressed: () => openPage(context, AppPage.login),
                  child: const Text(
                    'LOG IN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      openPage(context, AppPage.editorial, clear: true),
                  child: const Text(
                    'Explore as guest →',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.signUp = false});
  final bool signUp;
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();
  final repeat = TextEditingController();
  bool obscure = true, accepted = false;
  @override
  void dispose() {
    for (final c in [name, password, email, repeat]) {
      c.dispose();
    }
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    if (widget.signUp && !accepted) {
      toast(context, 'Please accept the Terms & Conditions.');
      return;
    }
    ShopScope.of(context).signIn(name.text, email.text);
    openPage(context, AppPage.editorial, clear: true);
  }

  Widget field(
    String label,
    TextEditingController controller, {
    bool secret = false,
    bool mail = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 19),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Colors.white,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: secret && obscure,
          key: ValueKey(label),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          keyboardType: mail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            isDense: true,
            hintText: mail
                ? 'you@example.com'
                : label == 'USERNAME'
                ? 'Your name'
                : '••••••••',
            hintStyle: const TextStyle(color: Colors.white70, fontSize: 12),
            errorStyle: const TextStyle(color: ink, fontSize: 10),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            suffixIcon: secret
                ? IconButton(
                    tooltip: 'Show password',
                    icon: Icon(
                      obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () => setState(() => obscure = !obscure),
                  )
                : null,
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'This field is required';
            if (secret && v.length < 6) return 'Use at least 6 characters';
            if (mail && !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v)) {
              return 'Enter a valid email';
            }
            if (label == 'REPEAT EMAIL' && v != email.text) {
              return 'Email addresses must match';
            }
            return null;
          },
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: true,
    body: Stack(
      fit: StackFit.expand,
      children: [
        asset(widget.signUp ? 'signup' : 'login', fit: BoxFit.cover),
        SafeArea(
          child: Column(
            children: [
              ShopHeader(
                title: widget.signUp ? 'Sign up' : 'Login',
                leadingBack: true,
                backLabel: 'Back',
                actions: false,
                dark: true,
                overlay: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 22),
                  child: Form(
                    key: form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.signUp
                              ? 'Life is pretty short to\nwear ugly things'
                              : 'Quality is not an act\nIt’s a natural habit.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            letterSpacing: -.8,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(width: 22, height: 2, color: Colors.white70),
                        SizedBox(height: widget.signUp ? 48 : 154),
                        field('USERNAME', name),
                        field('PASSWORD', password, secret: true),
                        if (widget.signUp) ...[
                          field('EMAIL', email, mail: true),
                          field('REPEAT EMAIL', repeat, mail: true),
                        ],
                        Row(
                          children: [
                            Checkbox(
                              value: accepted,
                              activeColor: mint,
                              side: const BorderSide(color: Colors.white),
                              onChanged: (v) => setState(() => accepted = v!),
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: widget.signUp
                                    ? () => showDialog<void>(
                                        context: context,
                                        builder: (c) => AlertDialog(
                                          title: const Text(
                                            'Terms & Conditions',
                                          ),
                                          content: const Text(
                                            'This is a local shopping demo. No account is created, '
                                            'no payment is collected and no order is transmitted.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(c),
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        ),
                                      )
                                    : null,
                                child: Text(
                                  widget.signUp
                                      ? 'Terms & Conditions'
                                      : 'Remember me',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ActionButton(
                          widget.signUp ? 'Sign up' : 'Log in',
                          light: true,
                          key: const ValueKey('auth-submit'),
                          onPressed: submit,
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'LOCAL DEMO · NO ACCOUNT REQUIRED',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 8,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
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

class EditorialPage extends StatelessWidget {
  const EditorialPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        asset('editorial', fit: BoxFit.cover),
        SafeArea(
          child: Column(
            children: [
              const ShopHeader(brand: true, overlay: true),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        '2K19 NEW COLLECTIONS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Quality is not an Act\nIt’s a Habit.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        '2  ━━━━━  6',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      const Spacer(),
                      const Text(
                        'Thoughtfully made. Beautifully worn.\nDiscover the pieces that become part of you.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ActionButton(
                              'Shop now',
                              light: true,
                              key: const ValueKey('shop-now'),
                              onPressed: () => openPage(
                                context,
                                AppPage.discover,
                                clear: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextButton(
                              onPressed: () => openPage(
                                context,
                                AppPage.discover,
                                clear: true,
                              ),
                              child: const Text(
                                'BROWSE MORE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
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
