import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';

class UserRepository {
  UserRepository(this._api);

  final ApiClient _api;

  Future<List<User>> getAll() async {
    try {
      final data = await _api.get(Uri.https(_api.host, '/users'));

      return (data as List<dynamic>)
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw BadResponseException('users: $e');
    }
  }

  Future<User> getById(int id) async {
    try {
      final data = await _api.get(Uri.https(_api.host, '/users/$id'));

      return User.fromJson(data as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw BadResponseException('users/$id: $e');
    }
  }

  Future<User> create(User draft) async {
    try {
      final uri = Uri.https(_api.host, '/users');
      final data = await _api.post(uri, draft.toJson());

      return User.fromJson(data as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } on FormatException catch (e) {
      throw BadResponseException(e.message);
    } catch (e) {
      throw BadResponseException('POST users: $e');
    }
  }
}
