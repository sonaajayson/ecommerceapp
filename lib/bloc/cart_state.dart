import 'package:ecommerceapp/models/cartmodel.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final int total;

  CartLoaded(this.items, this.total);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
