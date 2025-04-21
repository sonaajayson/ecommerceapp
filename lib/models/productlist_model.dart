class Product {
  final String id;
  final String name;
  final int price;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json, {String? id}) {
    return Product(
      id: id ?? '', // default empty string if id is null
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      image: json['image'] ?? '',
    );
  }
}
