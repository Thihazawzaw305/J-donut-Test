import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';
import 'package:j_donuts_app/core/router/app_routes.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/otp_boxes.dart';

import '../../helpers/in_memory_session_storage.dart';
import '../../helpers/pump_jdonuts_app.dart';

void main() {
  testWidgets('go register OTP ready after transition duration', (tester) async {
    await pumpJDonutsApp(
      tester,
      location: AppRoutes.registerOtp,
      settle: false,
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(OtpBoxes), findsOneWidget);
  });

  testWidgets('go product route ready after transition duration', (tester) async {
    final storage = InMemorySessionStorage();
    await storage.write('+959254135592');
    await pumpJDonutsApp(
      tester,
      location: AppRoutes.productPath('p_coconut'),
      settle: false,
      sessionStorage: storage,
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Coconut Donut'), findsOneWidget);
    expect(find.text('3,200 Ks'), findsWidgets);
  });
}
