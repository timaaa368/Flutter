import 'package:flutter/material.dart';

import 'add_book_screen.dart';
import 'detail_screen.dart';
import 'models/book.dart';
import 'widgets/book_tile.dart';

enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [...seed];
  Filter _filter = Filter.all;

  List<Book> get _visible => switch (_filter) {
    Filter.all => _books,
    Filter.unread => unread(_books),
    Filter.read => _books.where((b) => b.read).toList(),
  };

  Future<void> _openDetails(Book book) async {
    final action = await Navigator.of(context).push<BookAction>(
      MaterialPageRoute(builder: (_) => DetailScreen(book: book)),
    );

    if (!mounted) return;

    switch (action) {
      case BookAction.toggleRead:
        setState(() => book.read = !book.read);
      case BookAction.delete:
        setState(() => _books.remove(book));
      case null:
        break;
    }
  }

  Future<void> _addBook() async {
    final book = await Navigator.of(context)
        .push<Book>(MaterialPageRoute(builder: (_) => const AddBookScreen()));

    if (!mounted || book == null) return;

    setState(() => _books.add(book));
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    Widget statistic(String value, String label) {
      return Expanded(
        child: Column(
          children: [
            Text(
              value,
              style: textTheme.headlineSmall?.copyWith(color: colors.primary),
            ),
            Text(label, style: textTheme.bodySmall),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            statistic('${_books.length}', 'Books'),
            statistic('${totalPages(_books)}', 'Pages'),
            statistic('${unread(_books).length}', 'Unread'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = <Filter, String>{
      Filter.all: 'All',
      Filter.unread: 'Unread',
      Filter.read: 'Read',
    };

    return Scaffold(
      appBar: AppBar(title: Text('Reading list (${_visible.length})')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: filters.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(entry.value),
                      selected: _filter == entry.key,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _filter = entry.key);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _visible.isEmpty
                    ? const Center(child: Text('No books in this filter.'))
                    : ListView.builder(
                        itemCount: _visible.length,
                        itemBuilder: (context, index) {
                          final book = _visible[index];

                          return BookTile(
                            book: book,
                            onTap: () => _openDetails(book),
                            onToggle: () {
                              setState(() => book.read = !book.read);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        tooltip: 'Add a book',
        child: const Icon(Icons.add),
      ),
    );
  }
}
