import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/bloc/cart_event.dart';
import 'package:ecommerceapp/bloc/cart_state.dart';
import 'package:ecommerceapp/models/cartmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_loadCart);
    on<AddToCart>(_addToCart);
    on<UpdateQuantity>(_updateQuantity);
  }

  final userId = FirebaseAuth.instance.currentUser?.uid;

  // Load cart items from Firestore and calculate the total
  Future<void> _loadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      // Ensure the user is logged in before fetching the cart
      if (userId == null) {
        emit(CartError("User not logged in"));
        return;
      }

      emit(CartLoading());

      final snapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(userId)
          .collection('items')
          .get();

      final items = snapshot.docs
          .map((doc) => CartItem.fromJson(doc.data(), id: doc.id))
          .toList();

      final total = items.fold(0, (sum, item) => sum + item.price * item.quantity);

      emit(CartLoaded(items, total));  // Emit the loaded cart with total
    } catch (e) {
      emit(CartError("Failed to load cart: $e"));
    }
  }

  // Add an item to the cart (or update if it already exists)
  Future<void> _addToCart(AddToCart event, Emitter<CartState> emit) async {
    if (userId == null) {
      emit(CartError("User not logged in"));
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('cart')
        .doc(userId)
        .collection('items')
        .doc(event.item.id);

    final doc = await docRef.get();

    try {
      if (doc.exists) {
        await docRef.update({
          'quantity': FieldValue.increment(1),
        });
      } else {
        await docRef.set(event.item.toJson());
      }

      add(LoadCart());  // Refresh the cart after adding the item
    } catch (e) {
      emit(CartError("Failed to add item to cart: $e"));
    }
  }

  // Update the quantity of an item in the cart
  Future<void> _updateQuantity(UpdateQuantity event, Emitter<CartState> emit) async {
    if (userId == null) {
      emit(CartError("User not logged in"));
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(userId)
          .collection('items')
          .doc(event.id)
          .update({'quantity': event.quantity});

      add(LoadCart());  // Refresh the cart after quantity update
    } catch (e) {
      emit(CartError("Failed to update quantity: $e"));
    }
  }
}
