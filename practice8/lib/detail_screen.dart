import 'package:flutter/material.dart';

import 'models/book.dart';

enum BookAction { toggleRead, delete }

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.book});

  final Book book;

  Future<void> _deleteBook(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm deletion'),
          content: Text('Delete \'${book.title}\'?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!context.mounted || confirmed != true) return;

    Navigator.of(context).pop(BookAction.delete);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Book details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.menu_book, size: 48, color: colors.primary),
                  const SizedBox(height: 16),
                  Text(book.title, style: textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  Text('Author: ${book.author}', style: textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Text('Pages: ${book.pages}', style: textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Year: ${book.year ?? 'unknown'}',
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Status: ${book.read ? 'Read' : 'Unread'}',
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop(BookAction.toggleRead);
            },
            icon: Icon(
              book.read ? Icons.mark_email_unread : Icons.check_circle,
            ),
            label: Text(book.read ? 'Mark as unread' : 'Mark as read'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _deleteBook(context),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
