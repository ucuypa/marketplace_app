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
        ),
        Product(
          id: 'p-jordan',
          title: 'Nike Jordan',
          price: 59.99,
          imageAsset: 'assets/image/shoes.png',
          badge: 'BEST SELLER',
          isPopular: true,
          categories: [Category.mensShoes],
        ),
        Product(
          id: 'p-puma',
          title: 'PUMA x ONE PIECE Suede',
          price: 99.99,
          imageAsset: 'assets/image/puma.jpg',
          badge: 'COLLAB',
          isPopular: true,
          categories: [Category.mensShoes, Category.limited], // ⬅️ multiple categories!
        ),
        Product(
          id: 'p-adidas',
          title: 'Adidas',
          price: 75.99,
          imageAsset: 'assets/image/adidas.png',
          badge: 'TRENDING',
          isPopular: true,
          categories: [Category.mensShoes],
        ),
        Product(
          id: 'p-gucci',
          title: 'Gucci',
          price: 35.99,
          imageAsset: 'assets/image/gucci.png',
          badge: 'HOT',
          isPopular: true,
          categories: [Category.mensTShirt],
        ),
      ];
}
