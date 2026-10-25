import 'package:flutter/material.dart';

enum AppPage {
  splash,
  login,
  signup,
  editorial,
  discover,
  menu,
  category,
  filters,
  product,
  reviews,
  emptyCart,
  cart,
  shipping,
  payment,
  done,
  search,
  results,
  wishlist,
  map,
  scan,
  account,
  settings,
}

void openPage(BuildContext context, AppPage page, {bool clear = false}) {
  if (clear) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/${page.name}', (_) => false);
  } else {
    Navigator.of(context).pushNamed('/${page.name}');
  }
}

void back(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  } else {
    openPage(context, AppPage.discover, clear: true);
  }
}
