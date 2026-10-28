import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Use the bundled font, rather than Ahem, for shaping and overflow checks.
Future<void> loadCairoFonts() async {
  final loader = FontLoader('Cairo');
  for (final weight in [
    'ExtraLight',
    'Light',
    'Regular',
    'Medium',
    'SemiBold',
    'Bold',
    'ExtraBold',
    'Black',
  ]) {
    loader.addFont(rootBundle.load('assets/fonts/Cairo-$weight.ttf'));
  }
  await loader.load();
  await (FontLoader(
    'MaterialIcons',
  )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
}

/// Inspect resolved render spans: ThemeData assertions miss control overrides.
/// Icon-font spans are deliberately excluded.
void expectCairoText(WidgetTester tester, Finder scope) {
  var checked = 0;
  final textCharacters = RegExp(r'[A-Za-z0-9\u0600-\u06ff]');
  void checkSpan(InlineSpan span, TextStyle inherited) {
    final style = inherited.merge(span.style);
    if (span is TextSpan && textCharacters.hasMatch(span.text ?? '')) {
      expect(style.fontFamily, 'Cairo', reason: 'Rendered text: ${span.text}');
      checked++;
    }
    if (span is TextSpan) {
      for (final child in span.children ?? const <InlineSpan>[]) {
        checkSpan(child, style);
      }
    }
  }

  final richTexts = find.descendant(of: scope, matching: find.byType(RichText));
  for (final paragraph in tester.renderObjectList<RenderParagraph>(richTexts)) {
    checkSpan(paragraph.text, const TextStyle());
  }
  for (final editable in tester.widgetList<EditableText>(
    find.descendant(of: scope, matching: find.byType(EditableText)),
  )) {
    // PIN packages use a transparent EditableText only to capture input;
    // their visible digit cells are checked as RenderParagraphs above.
    if (editable.style.color?.a == 0) continue;
    expect(editable.style.fontFamily, 'Cairo');
    checked++;
  }
  expect(checked, greaterThan(0), reason: 'The scope must render actual text.');
}
