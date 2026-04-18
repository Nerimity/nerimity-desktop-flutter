import 'api_client.dart';

Future<List<dynamic>> loadMessages(String channelId) async {
  final response = await dio.get('/channels/$channelId/messages');
  return response.data as List<dynamic>;
}
