import 'api_client.dart';

Future<String> userLogin(String email, String password) async {
  final response = await dio.post(
    '/users/login',
    data: {'email': email, 'password': password},
  );
  return response.data['token'] as String;
}
