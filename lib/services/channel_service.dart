import 'api_client.dart';

Future<List<dynamic>> loadMessages(String channelId) async {
  final response = await dio.get('/channels/$channelId/messages');
  return response.data as List<dynamic>;
}

Future<Map<String, dynamic>> postMessage(
  String channelId,
  String content,
) async {
  final response = await dio.post(
    '/channels/$channelId/messages',
    data: {'content': content},
  );
  return response.data as Map<String, dynamic>;
}
