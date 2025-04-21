import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerceapp/bloc/cart_bloc.dart';
import 'package:ecommerceapp/bloc/cart_state.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: const Color.fromARGB(255, 29, 55, 99),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded && state.items.isNotEmpty) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Image.network(item.image, width: 50, height: 50),
                    title: Text(item.name),
                    subtitle: Text("Quantity: ${item.quantity}"),
                    trailing: Text("₹${item.price * item.quantity}"),
                  ),
                );
              },
            );
          } else if (state is CartLoaded && state.items.isEmpty) {
            return const Center(child: Text("No orders placed yet."));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
