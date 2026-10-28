import 'package:dllne_deliver_app/common/design/src/widgets/directional_navigation_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'delivery navigation keeps glyph shape and mirrors only direction',
    (tester) async {
      Future<void> pump(TextDirection direction) => tester.pumpWidget(
        Directionality(
          textDirection: direction,
          child: const DirectionalNavigationIcon(
            purpose: NavigationArrowPurpose.back,
            childPointsRight: false,
            child: Icon(Icons.arrow_back_ios_new),
          ),
        ),
      );

      await pump(TextDirection.rtl);
      expect(
        tester.widget<Transform>(find.byType(Transform)).transform.storage[0],
        -1,
      );
      expect(
        tester.widget<Icon>(find.byType(Icon)).icon,
        Icons.arrow_back_ios_new,
      );

      await pump(TextDirection.ltr);
      expect(
        tester.widget<Transform>(find.byType(Transform)).transform.storage[0],
        1,
      );
    },
  );
}
