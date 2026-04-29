bool isValidUrl(String url) {
  try {
    final uri = Uri.parse(url);
    return uri.hasAbsolutePath && uri.hasScheme;
  } catch (e) {
    return false;
  }
}
