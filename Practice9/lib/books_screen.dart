import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/book.dart';
import 'models/cart.dart';
import 'cart_badge.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');

    final filteredBooks = books.where((book) {
      return book.title.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Shop'),
        actions: const [CartBadge()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search books...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];

                return BookRow(book: book);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Separate widget for each book
class BookRow extends StatelessWidget {
  final Book book;

  const BookRow({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    debugPrint('row ${book.title}');

    final added = context.select<Cart, bool>(
      (cart) => cart.items.contains(book),
    );

    return ListTile(
      title: Text(book.title),
      subtitle: Text('${book.author} • ${book.price} ₸'),
      trailing: added
          ? const Text(
              'Added',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            )
          : OutlinedButton(
              onPressed: () {
                final ok = context.read<Cart>().add(book);

                if (ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
    );
  }
}
