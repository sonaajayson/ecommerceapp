import 'package:ecommerceapp/models/cartmodel.dart';

abstract class CartEvent {}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final CartItem item;
  AddToCart(this.item);
}

class UpdateQuantity extends CartEvent {
  final String id;
  final int quantity;
  UpdateQuantity({required this.id, required this.quantity});
}
