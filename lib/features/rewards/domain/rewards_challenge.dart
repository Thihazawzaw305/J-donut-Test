bool challengeIsComplete({required int current, required int total}) {
  return total > 0 && current >= total;
}

bool challengeEarnEnabled({required int current, required int total}) {
  return challengeIsComplete(current: current, total: total);
}

double challengeProgressFraction({required int current, required int total}) {
  if (total <= 0) return 0;
  final raw = current / total;
  if (raw <= 0) return 0;
  if (raw >= 1) return 1;
  return raw;
}
