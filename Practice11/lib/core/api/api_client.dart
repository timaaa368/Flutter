import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  ApiClient(this._client, {this.host = 'jsonplaceholder.typicode.com'});

  final http.Client _client;
  final String host;

  Map<String, String> get headers => {'Accept': 'application/json'};

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      final response = await call().timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        log('${response.statusCode} ${response.request?.url}', name: 'api');
      }

      return response;
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    }
  }

  void _check(http.Response response) {
    if (response.statusCode == 401) {
      throw const UnauthorizedException();
    }

    if (response.statusCode == 404) {
      throw const NotFoundException();
    }

    if (response.statusCode >= 500) {
      throw ServerException(response.statusCode);
    }
  }

  dynamic _decode(http.Response response) {
    try {
      return jsonDecode(response.body);
    } on FormatException catch (e) {
      throw BadResponseException(e.message);
    }
  }

  Future<dynamic> get(Uri uri) async {
    final response = await _send(() => _client.get(uri, headers: headers));

    _check(response);
    return _decode(response);
  }

  Future<dynamic> post(Uri uri, Map<String, dynamic> body) async {
    final response = await _send(
      () => _client.post(
        uri,
        headers: {...headers, 'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ),
    );

    _check(response);
    return _decode(response);
  }
}
