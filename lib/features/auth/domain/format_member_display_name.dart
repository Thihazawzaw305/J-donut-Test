/// Display name for Home header after registration (Myanmar: last name optional).
String formatMemberDisplayName({
  required String firstName,
  String? lastName,
}) {
  final first = firstName.trim();
  final last = lastName?.trim() ?? '';
  if (first.isEmpty) return last;
  if (last.isEmpty) return first;
  return '$first $last';
}
