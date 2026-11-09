class DateOfBirth {
  const DateOfBirth({
    required this.year,
    required this.month,
    required this.day,
  });

  final int year;
  final int month;
  final int day;

  DateTime toDate() => DateTime(year, month, day);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateOfBirth &&
          other.year == year &&
          other.month == month &&
          other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);
}
