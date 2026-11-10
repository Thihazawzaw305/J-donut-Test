import '../../catalog/domain/entities/catalog_member.dart';

double rewardsRingSweepFraction(CatalogMember member) {
  final raw = member.tierLadderFillBp / 10000.0;
  if (raw <= 0) return 0;
  if (raw >= 1) return 1;
  return raw;
}
