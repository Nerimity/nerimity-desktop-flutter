String buildImageUrl(String url, {int? size}) {
  final uri = Uri.parse(url);

  final endsWithGif = uri.path.endsWith('.gif');
  final endsWithHashA = uri.fragment == 'a';

  if (!endsWithGif && !endsWithHashA) return url;

  final newParams = Map<String, String>.from(uri.queryParameters)
    ..['type'] = 'webp';

  if (size != null) newParams['size'] = size.toString();

  return uri.replace(queryParameters: newParams).toString();
}
