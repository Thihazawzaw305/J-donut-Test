import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/welcome_hero_image.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  const viewport = Size(400, 600);

  testWidgets('welcome hero fills viewport behind fade', (tester) async {
    await tester.pumpApp(
      MediaQuery(
        data: const MediaQueryData(size: viewport),
        child: const WelcomeHeroImage(),
      ),
    );
    await tester.pump();

    final box = tester.renderObject<RenderBox>(
      find.byKey(const Key('welcome_hero_image')),
    );
    expect(box.size.height, closeTo(viewport.height, 1));
    expect(box.size.width, closeTo(viewport.width, 1));
  });
}
