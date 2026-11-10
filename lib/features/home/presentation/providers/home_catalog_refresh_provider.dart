import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_motion.dart';
import '../../../../core/di/catalog_providers.dart';

/// True while pull-to-refresh is syncing the DB and reloading catalog streams.
final homeCatalogRefreshingProvider =
    NotifierProvider<HomeCatalogRefreshingNotifier, bool>(
      HomeCatalogRefreshingNotifier.new,
    );

class HomeCatalogRefreshingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setRefreshing(bool value) => state = value;
}

/// Pull-to-refresh: donut lead-in, then section skeletons, then data.
Future<void> handleHomePullRefresh(WidgetRef ref) async {
  if (ref.read(homeCatalogRefreshingProvider)) return;

  await Future<void>.delayed(AppMotion.homeRefreshSpinLeadIn);

  final notifier = ref.read(homeCatalogRefreshingProvider.notifier);
  notifier.setRefreshing(true);
  await Future<void>.delayed(Duration.zero);
  try {
    await reloadHomeCatalogFromDatabase(ref);
  } finally {
    notifier.setRefreshing(false);
  }
}
