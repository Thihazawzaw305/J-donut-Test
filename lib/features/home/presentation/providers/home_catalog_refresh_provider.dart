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

/// Pull-to-refresh: show home skeleton, sync seed → DB, await fresh stream data.
Future<void> handleHomePullRefresh(WidgetRef ref) async {
  if (ref.read(homeCatalogRefreshingProvider)) return;

  final notifier = ref.read(homeCatalogRefreshingProvider.notifier);
  notifier.setRefreshing(true);
  try {
    await Future<void>.delayed(AppMotion.homeRefreshSpinLeadIn);
    await reloadHomeCatalogFromDatabase(ref);
  } finally {
    notifier.setRefreshing(false);
  }
}
