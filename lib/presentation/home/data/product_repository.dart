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
          badge: 'NEW ARRIVAL',
          isPopular: true,
          categories: [Category.mensShoes, Category.limited], // ⬅️ multiple categories!
        ),
        Product(
          id: 'p-adidas',
          title: 'Adidas Originals',
          price: 75.99,
          imageAsset: 'assets/image/shoes.png',
          badge: 'TRENDING',
          isPopular: true,
          categories: [Category.mensShoes],
        ),
        Product(
          id: 'p-nike-shirt',
          title: 'Nike Dri-FIT Tee',
          price: 35.99,
          imageAsset: 'assets/image/stussy.png',
          badge: 'LIMITED',
          isPopular: true,
          categories: [Category.mensTShirt, Category.limited],
        ),
      ];
}
