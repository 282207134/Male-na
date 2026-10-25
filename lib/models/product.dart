class Product {
  const Product(
    this.id,
    this.name,
    this.image,
    this.price, {
    this.category = 'Bags',
    this.material = 'Leather',
    this.rating = 4.8,
  });
  final String id, name, image, category, material;
  final int price;
  final double rating;
}

class Order {
  const Order({
    required this.id,
    required this.total,
    required this.quantity,
    required this.shipping,
    required this.date,
  });
  final String id, shipping;
  final int total, quantity;
  final DateTime date;
}

String money(num value, {bool decimals = false}) {
  final digits = value.round().toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  return '\$$digits${decimals ? '.00' : ''}';
}
