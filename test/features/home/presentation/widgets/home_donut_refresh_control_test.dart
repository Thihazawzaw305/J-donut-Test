import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_dimens.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_donut_refresh_control.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  test('refresh runs only after spin lead-in', () async {
    final started = Stopwatch()..start();
    var refreshed = false;

    await HomeDonutRefreshControl.refreshWithSpinLeadIn(() async {
      refreshed = true;
    });

    expect(refreshed, isTrue);
    expect(
      started.elapsed,
      greaterThanOrEqualTo(AppMotion.homeRefreshSpinLeadIn),
    );
  });

  testWidgets('donut refresh indicator shows bundled asset while pulling', (
    tester,
  ) async {
    await tester.pumpApp(
      const HomeDonutRefreshIndicator(
        refreshState: RefreshIndicatorMode.drag,
        pulledExtent: 72,
        refreshTriggerPullDistance: 88,
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('home_refresh_donut_image')), findsOneWidget);

    final image = tester.widget<Image>(
      find.byKey(const Key('home_refresh_donut_image')),
    );
    expect(image.width, AppDimens.homeRefreshDonutSize);
  });
}
