import '../models/product.dart';

const products = [
  Product('brown', 'Leather Brown Bag', 'brown', 1990),
  Product('cream', 'Creamy Bag', 'cream', 2390),
  Product('croc', 'Leather Croc', 'croc', 2990),
  Product('black', 'Leather Blkk', 'black', 1690),
  Product(
    'sunglasses',
    'Black Sunglasses',
    'sunglasses',
    1290,
    category: 'Eyewear',
    material: 'Acetate',
    rating: 4.5,
  ),
  Product(
    'earrings',
    'Gold Earrings',
    'earrings',
    2390,
    category: 'Jewellery',
    material: 'Gold',
    rating: 4.7,
  ),
  Product(
    'watch',
    'Classic Duo Watch',
    'watch',
    890,
    category: 'Wearables',
    material: 'Steel',
    rating: 4.6,
  ),
  Product(
    'beauty',
    'Everyday Beauty Set',
    'beauty',
    190,
    category: 'Beauty',
    material: 'Beauty',
    rating: 4.4,
  ),
];
