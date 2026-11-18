import 'package:flutter/foundation.dart';

import 'book.dart';

class Cart extends ChangeNotifier {
  final Map<Book, int> _qty = {};

  List<Book> get items => List.unmodifiable(_qty.keys);

  int get count => _qty.length;

  int get total {
    int sum = 0;
    _qty.forEach((book, quantity) {
      sum += book.price * quantity;
    });
    return sum;
  }

  int qtyOf(Book book) => _qty[book] ?? 0;

  bool add(Book book) {
    if (_qty.containsKey(book)) {
      return false;
    }

    _qty[book] = 1;
    notifyListeners();
    return true;
  }

  void remove(Book book) {
    _qty.remove(book);
    notifyListeners();
  }

  void increment(Book book) {
    if (_qty.containsKey(book)) {
      _qty[book] = _qty[book]! + 1;
      notifyListeners();
    }
  }

  void clear() {
    _qty.clear();
    notifyListeners();
  }
}
