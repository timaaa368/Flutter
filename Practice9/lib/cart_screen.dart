import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';
import 'models/book.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          TextButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: const Text('Clear cart?'),
                    content: const Text(
                      'Are you sure you want to remove all books?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, true);
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  );
                },
              );

              if (!context.mounted) return;

              if (confirm == true) {
                context.read<Cart>().clear();
              }
            },
            child: const Text('Clear cart'),
          ),
        ],
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text('Your cart is empty', style: TextStyle(fontSize: 20)),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final Book book = cart.items[index];

                    return ListTile(
                      title: Text(book.title),
                      subtitle: Text('${book.price} ₸ × ${cart.qtyOf(book)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              cart.increment(book);
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                          IconButton(
                            onPressed: () {
                              cart.remove(book);
                            },
                            icon: const Icon(Icons.close, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Consumer<Cart>(
                  builder: (context, cart, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        child!,
                        Text(
                          '${cart.total} ₸',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.payment),
                      SizedBox(width: 8),
                      Text('Total:', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
