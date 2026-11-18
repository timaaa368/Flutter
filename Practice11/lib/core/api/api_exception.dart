sealed class ApiException implements Exception {
  const ApiException();
}

// Интернет жоқ немесе сұраныс уақыты бітті
class NoConnectionException extends ApiException {
  const NoConnectionException();
}

// Сервер қатесі (500 және одан жоғары)
class ServerException extends ApiException {
  const ServerException(this.status);

  final int status;
}

// Қолданушы табылмады (404)
class NotFoundException extends ApiException {
  const NotFoundException();
}

// Рұқсат жоқ (401)
class UnauthorizedException extends ApiException {
  const UnauthorizedException();
}

// JSON жауабын оқу мүмкін болмады
class BadResponseException extends ApiException {
  const BadResponseException([this.detail]);

  final String? detail;
}
