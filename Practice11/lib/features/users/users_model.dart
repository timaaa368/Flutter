import 'package:flutter/foundation.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'user_repository.dart';

class UsersModel extends ChangeNotifier {
  UsersModel(this._repo);

  final UserRepository _repo;

  List<User> items = const [];
  ApiException? error;
  bool loading = false;
  bool creating = false;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      items = await _repo.getAll();
    } on ApiException catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<User> create(User draft) async {
    creating = true;
    notifyListeners();

    try {
      final user = await _repo.create(draft);
      items = [user, ...items];
      error = null;
      return user;
    } on ApiException catch (e) {
      error = e;
      rethrow;
    } finally {
      creating = false;
      notifyListeners();
    }
  }
}
