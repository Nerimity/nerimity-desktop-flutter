String buildImageUrl(String url, {int? size}) {
  final uri = Uri.parse(url);

  final endsWithGif = uri.path.endsWith('.gif');
  final endsWithHashA = uri.fragment == 'a';
  final isAnimated = endsWithGif || endsWithHashA;

  if (!isAnimated && size == null) return url;

  final newParams = Map<String, String>.from(uri.queryParameters);

  if (isAnimated) newParams['type'] = 'webp';
  if (size != null) newParams['size'] = size.toString();

  return uri.replace(queryParameters: newParams).toString();
}
