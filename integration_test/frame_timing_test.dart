import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:j_donuts_app/app.dart';
import 'package:j_donuts_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/session_providers.dart';

import '../test/helpers/in_memory_session_storage.dart';
import '../test/helpers/select_birthday.dart';

/// Run in profile mode on a real device:
/// `flutter test integration_test/frame_timing_test.dart --profile -d <id>`
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Real vsync frames, not frames pumped on a fake clock.
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  const frameBudget = Duration(microseconds: 16667);
  final frames = <FrameTiming>[];

  void report(String phase, List<FrameTiming> slice) {
    if (slice.isEmpty) return;
    Duration p(List<Duration> d, double q) =>
        (d..sort())[((d.length - 1) * q).round()];
    final build = slice.map((f) => f.buildDuration).toList();
    final raster = slice.map((f) => f.rasterDuration).toList();
    final janky = slice
        .where(
          (f) =>
              f.buildDuration > frameBudget || f.rasterDuration > frameBudget,
        )
        .length;
    // ignore: avoid_print
    print(
      'PERF $phase frames=${slice.length} '
      'build p50=${p(build, .5).inMicroseconds / 1000}ms '
      'p90=${p(build, .9).inMicroseconds / 1000}ms '
      'p99=${p(build, .99).inMicroseconds / 1000}ms | '
      'raster p50=${p(raster, .5).inMicroseconds / 1000}ms '
      'p90=${p(raster, .9).inMicroseconds / 1000}ms '
      'p99=${p(raster, .99).inMicroseconds / 1000}ms | '
      'janky=$janky (${(100 * janky / slice.length).toStringAsFixed(1)}%)',
    );
  }

  testWidgets('frame timings across the flow', (tester) async {
    // Live binding returns from pumpAndSettle before navigation starts.
    Future<void> settle([Duration max = const Duration(seconds: 10)]) async {
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle(max);
    }

    final TimingsCallback cb = frames.addAll;
    tester.binding.addTimingsCallback(cb);

    var mark = 0;
    Future<void> phase(String name) async {
      // Timings are delivered asynchronously; give them time to arrive.
      await tester.pump(const Duration(milliseconds: 500));
      report(name, frames.sublist(mark));
      mark = frames.length;
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStorageProvider.overrideWithValue(InMemorySessionStorage()),
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(latency: Duration.zero),
          ),
        ],
        child: const JDonutsApp(),
      ),
    );
    await settle(const Duration(seconds: 3));
    await phase('onboarding');

    await tester.tap(find.text("LET'S GET STARTED"));
    await settle();
    await tester.enterText(find.byType(TextField), '09254135592');
    await settle();
    await tester.tap(find.text('CONTINUE'));
    await settle(const Duration(seconds: 2));
    await phase('phone->otp');

    await tester.enterText(find.byType(TextField), '123456');
    await settle();
    await tester.enterText(find.byType(TextField).first, 'Ada');
    await settle();
    await tester.tap(find.text('CONTINUE'));
    await settle();
    await selectBirthdayInTest(tester, DateTime(2000, 5, 30));
    await tester.tap(find.text('CONTINUE'));
    await settle(const Duration(seconds: 2));
    await phase('name->dob->check');

    await tester.tap(find.text("LET'S EXPLORE"));
    await settle(const Duration(seconds: 5));
    await phase('welcome->home');

    await tester.fling(
      find.byType(Scrollable).first,
      const Offset(0, -600),
      1500,
    );
    await settle();
    await phase('home scroll');

    await tester.tap(find.text('Reward'));
    await settle(const Duration(seconds: 4));
    await phase('rewards entrance');

    await tester.tap(find.text('Home'));
    await settle(const Duration(seconds: 2));
    final coconut = find.text('Coconut Donut').first;
    await tester.scrollUntilVisible(
      coconut,
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(coconut);
    await settle(const Duration(seconds: 4));
    await phase('product hero');

    tester.binding.removeTimingsCallback(cb);
    report('TOTAL', frames);
  });
}
