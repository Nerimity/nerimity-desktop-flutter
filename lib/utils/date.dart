String formatTimestamp(int milliseconds) {
  final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateOnly = DateTime(date.year, date.month, date.day);

  final time =
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

  if (dateOnly == today) {
    return time;
  } else if (dateOnly == yesterday) {
    return 'Yesterday at $time';
  } else {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year} at $time';
  }
}
