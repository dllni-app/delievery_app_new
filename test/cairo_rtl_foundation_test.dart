import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dllne_deliver_app/common/design/src/theme/theme/theme_collection.dart';
import 'package:dllne_deliver_app/common/design/src/widgets/directional_navigation_icon.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final cairo = FontLoader('Cairo')
      ..addFont(rootBundle.load('assets/fonts/Cairo-Regular.ttf'));
    await cairo.load();
  });

  test('application text theme resolves to Cairo', () {
    expect(
      ThemeCollection.lightTheme.textTheme.bodyMedium?.fontFamily,
      'Cairo',
    );
  });

  testWidgets('date picker inherits Cairo from the application theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeCollection.lightTheme,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => showDatePicker(
                context: context,
                initialDate: DateTime(2026, 10, 30),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              ),
              child: const Text('فتح التاريخ'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('فتح التاريخ'));
    await tester.pumpAndSettle();
    final dialogContext = tester.element(find.byType(DatePickerDialog));
    expect(Theme.of(dialogContext).textTheme.bodyMedium?.fontFamily, 'Cairo');
  });

  testWidgets('semantic arrows point correctly in RTL and LTR', (tester) async {
    Future<double> horizontalScale(
      NavigationArrowPurpose purpose,
      TextDirection direction,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: direction,
          child: DirectionalNavigationIcon(
            purpose: purpose,
            childPointsRight: false,
            child: const Icon(Icons.arrow_back),
          ),
        ),
      );
      return tester
          .widget<Transform>(find.byType(Transform))
          .transform
          .storage[0];
    }

    expect(
      await horizontalScale(NavigationArrowPurpose.back, TextDirection.rtl),
      -1,
    );
    expect(
      await horizontalScale(NavigationArrowPurpose.back, TextDirection.ltr),
      1,
    );
    expect(
      await horizontalScale(NavigationArrowPurpose.forward, TextDirection.rtl),
      1,
    );
    expect(
      await horizontalScale(NavigationArrowPurpose.forward, TextDirection.ltr),
      -1,
    );
  });
}
