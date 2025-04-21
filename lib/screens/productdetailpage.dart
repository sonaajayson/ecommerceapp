import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/bloc/cart_bloc.dart';
import 'package:ecommerceapp/bloc/cart_event.dart';
import 'package:ecommerceapp/models/cartmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/productlist_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  Future<void> addToWishlist(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be logged in to add to wishlist')),
      );
      return;
    }

    final wishlistRef = FirebaseFirestore.instance
        .collection('wishlist')
        .doc(user.uid)
        .collection('items')
        .doc(product.id); // using product id to avoid duplicates

    await wishlistRef.set({
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'image': product.image,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to Wishlist')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(product.image, height: 200)),
            const SizedBox(height: 20),
            Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Price: ₹${product.price}", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text(
              "Description:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              "This plant is perfect for home or office decor. It improves air quality and adds a touch of nature to your space.",
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
    final cartItem = CartItem(
      id: product.id,
      name: product.name,
      image: product.image,
      price: product.price,
      quantity: 1,
    );

    context.read<CartBloc>().add(AddToCart(cartItem));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to cart")),
    );
  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("Add to Cart"),
                ),
                OutlinedButton.icon(
                  onPressed: () => addToWishlist(context),
                  icon: const Icon(Icons.favorite_border),
                  label: const Text("Add to Wishlist"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
