import '../../../core/constants/app_dimens.dart';
import '../../catalog/domain/entities/catalog_member.dart';

double rewardsRingSweepFraction(CatalogMember member) {
  final raw = member.tierLadderFillBp / 10000.0;
  if (raw <= 0) return 0;
  if (raw >= 1) return 1;
  return raw;
}

/// Ring arc target on entrance: member tier fill scaled to the design arc cap.
double rewardsDonutRingTarget(CatalogMember member) {
  return rewardsRingSweepFraction(member) * AppDimens.rewardsDonutDisplaySweep;
}
