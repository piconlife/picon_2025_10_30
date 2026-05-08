import 'package:flutter_entity/entity.dart';

class ProductKey extends EntityKey {
  static const name = 'name';
  static const price = 'price';
  static const category = 'category';
  static const tags = 'tags';
  static const stock = 'stock';
}

class Product extends Entity {
  final String name;
  final double price;
  final String category;
  final List<String> tags;
  final int stock;

  Product({
    required super.id,
    required this.name,
    required this.price,
    required this.category,
    required this.tags,
    required this.stock,
  });

  factory Product.from(dynamic source) {
    final map = source is Map<String, dynamic> ? source : <String, dynamic>{};
    return Product(
      id: EntityHelper.generateID,
      name: map[ProductKey.name] ?? '',
      price: (map[ProductKey.price] ?? 0).toDouble(),
      category: map[ProductKey.category] ?? '',
      tags: List<String>.from(map[ProductKey.tags] ?? []),
      stock: map[ProductKey.stock] ?? 0,
    );
  }

  @override
  Map<String, dynamic> get source => {
    ProductKey.name: name,
    ProductKey.price: price,
    ProductKey.category: category,
    ProductKey.tags: tags,
    ProductKey.stock: stock,
  };

  Product copyWith({
    String? name,
    double? price,
    String? category,
    List<String>? tags,
    int? stock,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      stock: stock ?? this.stock,
    );
  }
}
