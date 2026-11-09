/// Formats what the user sees in the national-number field (after the +95 prefix).
///
/// Removes one leading trunk `0` from the digit sequence while keeping spaces,
/// dashes, and an optional leading `+`.
String normalizePhoneInputForDisplay(String raw) {
  if (raw.isEmpty) return raw;

  final buffer = StringBuffer();
  var sawFirstDigit = false;
  var skippedLeadingZero = false;

  for (final codeUnit in raw.codeUnits) {
    final char = String.fromCharCode(codeUnit);
    if (char == '+' || char == ' ' || char == '-') {
      buffer.write(char);
      continue;
    }
    if (char.codeUnitAt(0) >= 0x30 && char.codeUnitAt(0) <= 0x39) {
      if (!sawFirstDigit) {
        sawFirstDigit = true;
        if (char == '0' && !skippedLeadingZero) {
          skippedLeadingZero = true;
          continue;
        }
      }
      buffer.write(char);
    }
  }
  return buffer.toString();
}
