import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';
import 'books_screen.dart';
import 'cart_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => Cart(), child: const Shell()));
}

class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const BooksScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
