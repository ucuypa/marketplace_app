import '../models/product.dart';

class ProductRepository {
  const ProductRepository();

  List<Product> fetchAll() => const [
    Product(
      id: 'p-stussy',
      title: 'Stussy Angel',
      price: 40.99,
      imageAsset: 'assets/image/stussy.png',
      badge: 'BEST SELLER',
      isPopular: true,
      categories: [Category.mensTShirt],
      description:
          'The Stussy Angel Tee delivers a clean, street-ready look with an oversized front graphic printed on 100% combed cotton. Soft hand-feel, breathable, and perfect for daily wear.',
    ),
    Product(
      id: 'p-jordan',
      title: 'Nike Jordan',
      price: 59.99,
      imageAsset: 'assets/image/shoes.png',
      badge: 'BEST SELLER',
      isPopular: true,
      categories: [Category.mensShoes],
      description:
          'Air Jordan features responsive cushioning with a lightweight mesh upper for ventilation. Grippy rubber outsole and supportive midfoot cage—built for court and casual.',
    ),
    Product(
      id: 'p-puma',
      title: 'PUMA x ONE PIECE Suede',
      price: 99.99,
      imageAsset: 'assets/image/puma.jpg',
      badge: 'COLLAB',
      isPopular: true,
      categories: [Category.mensShoes, Category.limited],
      description:
          'Limited PUMA x ONE PIECE collab. Premium suede upper, cushioned insole, and anime-inspired accents for a collectible look you can actually wear.',
    ),
    Product(
      id: 'p-adidas',
      title: 'Adidas',
      price: 75.99,
      imageAsset: 'assets/image/adidas.png',
      badge: 'TRENDING',
      isPopular: true,
      categories: [Category.mensShoes],
      description:
          'Classic Adidas runner with Cloudfoam cushioning for all-day comfort. Durable traction outsole and minimalist styling that pairs with any fit.',
    ),
    Product(
      id: 'p-gucci',
      title: 'Gucci',
      price: 35.99,
      imageAsset: 'assets/image/gucci.png',
      badge: 'HOT',
      isPopular: true,
      categories: [Category.mensTShirt],
      description:
          'Premium cotton tee with tailored fit and soft-touch finish. Subtle graphic hit on chest—elevated basics for an effortless look.',
    ),
  ];
}
