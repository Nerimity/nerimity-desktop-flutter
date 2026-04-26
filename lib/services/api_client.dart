import 'package:dio/dio.dart';
import '../../config.dart';

final dio = Dio(
  BaseOptions(baseUrl: apiUrl, headers: {'Content-Type': 'application/json'}),
);
