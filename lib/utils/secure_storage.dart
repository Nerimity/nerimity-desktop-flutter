import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();
String? _cachedToken;

Future<String?> getToken() async {
  if (_cachedToken != null) return _cachedToken;
  try {
    _cachedToken = await _storage.read(key: 'token');
  } catch (_) {}
  return _cachedToken;
}

Future<void> saveToken(String token) async {
  _cachedToken = token;
  try {
    await _storage.write(key: 'token', value: token);
  } catch (_) {}
}

Future<void> deleteToken() async {
  _cachedToken = null;
  try {
    await _storage.delete(key: 'token');
  } catch (_) {}
}
