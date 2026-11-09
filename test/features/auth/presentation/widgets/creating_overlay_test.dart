import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/creating_overlay.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('Creating pill is centered and a fill barrier blocks taps', (
    tester,
  ) async {
    var leakedTaps = 0;
    await tester.pumpApp(
      Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => leakedTaps++,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
          const CreatingOverlay(),
        ],
      ),
    );

    expect(find.text('Creating...'), findsOneWidget);
    final barrier = tester.widget<Positioned>(
      find.ancestor(
        of: find.text('Creating...'),
        matching: find.byType(Positioned),
      ),
    );
    expect(barrier.top, 0);
    expect(barrier.left, 0);
    expect(barrier.right, 0);
    expect(barrier.bottom, 0);

    await tester.tapAt(const Offset(12, 12));
    await tester.pump();
    expect(leakedTaps, 0);
  });
}
