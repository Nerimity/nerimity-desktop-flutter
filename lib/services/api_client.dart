// lib/api/api_client.dart
import 'package:dio/dio.dart';
import '../../config.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: apiUrl,
    headers: {'Content-Type': 'application/json', "Authorization": userToken},
  ),
);

void setAuthToken(String token) {
  dio.options.headers['Authorization'] = token;
}
