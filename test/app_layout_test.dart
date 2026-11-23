import 'package:crust_food/app/crust_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app uses phone width on desktop and full width on phones', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ProviderScope(child: CrustApp()));
    await tester.pumpAndSettle();

    final phoneViewport = find.byKey(const ValueKey('app-phone-viewport'));
    expect(phoneViewport, findsOneWidget);
    expect(tester.getSize(phoneViewport).width, 430);

    tester.view.physicalSize = const Size(390, 844);
    await tester.pump();

    expect(phoneViewport, findsNothing);
    expect(tester.takeException(), isNull);
  });
}
