import 'package:flutter/material.dart';

import 'models/book.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _pagesController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _pagesController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if ((value ?? '').trim().length < 2) {
      return 'Enter at least 2 characters';
    }
    return null;
  }

  String? _validateAuthor(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Author is required';
    }
    return null;
  }

  String? _validatePages(String? value) {
    final n = int.tryParse(value ?? '');

    if (n == null || n <= 0) {
      return 'A whole number above 0';
    }

    return null;
  }

  String? _validateYear(String? value) {
    final text = (value ?? '').trim();

    if (text.isEmpty) return null;

    final year = int.tryParse(text);
    final currentYear = DateTime.now().year;

    if (year == null || year < 1450 || year > currentYear) {
      return 'Enter a year from 1450 to $currentYear';
    }

    return null;
  }

  void _saveBook() {
    if (!_formKey.currentState!.validate()) return;

    final book = Book(
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      pages: int.parse(_pagesController.text.trim()),
      year: int.tryParse(_yearController.text.trim()),
    );

    Navigator.of(context).pop(book);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Add a book')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Book information', style: textTheme.headlineSmall),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.book),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateTitle,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: 'Author',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateAuthor,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pagesController,
                  decoration: const InputDecoration(
                    labelText: 'Pages',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.format_list_numbered),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: _validatePages,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearController,
                  decoration: const InputDecoration(
                    labelText: 'Year (optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: _validateYear,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  onFieldSubmitted: (_) => _saveBook(),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _saveBook,
                  icon: const Icon(Icons.save),
                  label: const Text('Save book'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
