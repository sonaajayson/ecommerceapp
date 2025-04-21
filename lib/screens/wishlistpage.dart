import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/models/productlist_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'productdetailpage.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  Future<List<Product>> fetchWishlist() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('wishlist')
        .doc(user.uid)
        .collection('items')
        .get();

    return snapshot.docs
        .map((doc) => Product.fromJson(doc.data(), id: doc.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Wishlist")),
      body: FutureBuilder<List<Product>>(
        future: fetchWishlist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Your wishlist is empty"));
          }

          final wishlistItems = snapshot.data!;
          return ListView.builder(
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              final product = wishlistItems[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(product.name),
                  subtitle: Text("₹${product.price}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: product),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
