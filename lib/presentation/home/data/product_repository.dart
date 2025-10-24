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
          category: Category.mensTShirt,
        ),
        Product(
          id: 'p-jordan',
          title: 'Nike Jordan',
          price: 59.99,
          imageAsset: 'assets/image/shoes.png',
          badge: 'BEST SELLER',
          isPopular: true,
          category: Category.mensShoes,
        ),
        // tambahkan produk lain jika perlu...
      ];
}
