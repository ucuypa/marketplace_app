// lib/presentation/seller/seller_dashboard_model.dart

class SellerProduct {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  SellerProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory SellerProduct.fromMap(String id, Map<String, dynamic> map) {
    return SellerProduct(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['previewImageUrl'] ?? '',
    );
  }
}

class SellerDashboardData {
  final String storeName;
  final String storeAddress;
  final double rating;
  final int salesCount;
  final int productCount;
  final String? storeAvatarUrl;
  final List<SellerProduct> products;

  SellerDashboardData({
    required this.storeName,
    required this.storeAddress,
    required this.rating,
    required this.salesCount,
    required this.productCount,
    this.storeAvatarUrl,
    required this.products,
  });

  SellerDashboardData copyWith({
    String? storeName,
    String? storeAddress,
    double? rating,
    int? salesCount,
    int? productCount,
    String? storeAvatarUrl,
    List<SellerProduct>? products,
  }) {
    return SellerDashboardData(
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      rating: rating ?? this.rating,
      salesCount: salesCount ?? this.salesCount,
      productCount: productCount ?? this.productCount,
      storeAvatarUrl: storeAvatarUrl ?? this.storeAvatarUrl,
      products: products ?? this.products,
    );
  }
}
