class CartItem {
  final String id;
  final String name;
  final String image;
  final int price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json, {required String id}) {
    return CartItem(
      id: id,
      name: json['name'],
      image: json['image'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'price': price,
    'quantity': quantity,
  };
}
