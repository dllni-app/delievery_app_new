import 'package:dllne_deliver_app/common/design/src/theme/theme/theme_collection.dart';
import 'package:dllne_deliver_app/common/design/src/widgets/auto_scroll_text_widget.dart';
import 'package:dllne_deliver_app/common/design/src/widgets/show_sheet.dart';
import 'package:dllne_deliver_app/features/auth/presentation/widgets/pin_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marquee/marquee.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'support/cairo_test_support.dart';

Widget _app(Widget child, {double scale = 1}) => MaterialApp(
  theme: ThemeCollection.lightTheme,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: Directionality(textDirection: TextDirection.rtl, child: child!),
  ),
  home: Scaffold(
    appBar: AppBar(title: const Text('تطبيق التوصيل')),
    body: child,
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadCairoFonts);

  testWidgets(
    'delivery independent control styles and real sheet render Cairo',
    (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => SingleChildScrollView(
              child: Column(
                children: [
                  FilledButton(onPressed: () {}, child: const Text('تأكيد')),
                  ElevatedButton(onPressed: () {}, child: const Text('حفظ')),
                  OutlinedButton(
                    onPressed: () => calls++,
                    child: const Text('تفاصيل الطلب'),
                  ),
                  const OutlinedButton(onPressed: null, child: Text('معطل')),
                  const Chip(label: Text('طلب جديد')),
                  const Text.rich(
                    TextSpan(
                      text: 'تفاصيل ',
                      children: [
                        TextSpan(
                          text: 'التوصيل',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    initialValue: 'أحمد',
                    decoration: const InputDecoration(
                      labelText: 'اسم السائق',
                      hintText: 'أدخل الاسم',
                      errorText: 'راجع البيانات',
                    ),
                  ),
                  TextButton(
                    onPressed: () => showCustomBottomSheet(
                      context: context,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('تأكيد تسليم الطلب'),
                            OutlinedButton(
                              onPressed: () {
                                calls++;
                                Navigator.pop(context);
                              },
                              child: const Text('إتمام التسليم'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: const Text('افتح النافذة'),
                  ),
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('تم التسليم'))),
                    child: const Text('إشعار'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      expectCairoText(tester, find.byType(Scaffold));
      await tester.tap(find.text('تفاصيل الطلب'));
      expect(calls, 1);
      await tester.tap(find.text('افتح النافذة'));
      await tester.pumpAndSettle();
      expectCairoText(tester, find.byType(BottomSheet));
      await tester.tap(find.text('إتمام التسليم'));
      await tester.pumpAndSettle();
      expect(calls, 2);
      expect(find.byType(BottomSheet), findsNothing);
      await tester.tap(find.text('إشعار'));
      await tester.pumpAndSettle();
      expectCairoText(tester, find.byType(SnackBar));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('verification code digits use Cairo', (tester) async {
    final controller = PinInputController(text: '123456');
    await tester.pumpWidget(_app(PinWidget(pinController: controller)));
    await tester.pump(const Duration(milliseconds: 300));
    expectCairoText(tester, find.byType(PinWidget));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  });

  for (final flexible in [false, true]) {
    testWidgets(
      'marquee uses Cairo metrics and text scaling: flexible=$flexible',
      (tester) async {
        const text = 'مرحبا بالعالم';
        const style = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
        final measured = <double>[];
        for (final scale in [1.0, 2.0]) {
          final painter = TextPainter(
            text: const TextSpan(
              text: text,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            textDirection: TextDirection.rtl,
            textScaler: TextScaler.linear(scale),
            maxLines: 1,
          )..layout();
          measured.add(painter.width);
          painter.dispose();
        }
        final width = (measured[0] + measured[1]) / 2;
        for (final scale in [1.0, 2.0]) {
          final child = flexible
              ? SizedBox(
                  width: width,
                  child: const FlexibleAutoScrollText(text: text, style: style),
                )
              : AutoScrollTextWidget(text: text, style: style, width: width);
          await tester.pumpWidget(_app(Center(child: child), scale: scale));
          await tester.pump(const Duration(milliseconds: 100));
          expect(
            find.byType(Marquee),
            scale == 2 ? findsOneWidget : findsNothing,
          );
          final scope = find.byType(
            flexible ? FlexibleAutoScrollText : AutoScrollTextWidget,
          );
          expectCairoText(tester, scope);
          if (scale == 2) {
            final marquee = tester.widget<Marquee>(find.byType(Marquee));
            expect(marquee.textDirection, TextDirection.rtl);
            expect(marquee.style?.fontFamily, 'Cairo');
          }
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
        }
      },
    );
  }

  testWidgets('nullable marquee styles and unbounded flexible width are safe', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AutoScrollTextWidget(
                text: 'نص قصير',
                style: null,
                width: 250,
              ),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: FlexibleAutoScrollText(
                  text: 'نص مرن',
                  textDirection: TextDirection.ltr,
                ),
              ),
            ],
          ),
        ),
        scale: 2,
      ),
    );
    expectCairoText(tester, find.byType(Scaffold));
    expect(find.byType(Marquee), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
