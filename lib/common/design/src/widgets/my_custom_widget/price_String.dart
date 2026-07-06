import 'package:easy_localization/easy_localization.dart';
import '../../../../helper/src/locale_keys.dart';

  String getPriceWithName(double price) {
    // ✅ أقل من 1000 → عادي مع العملة
    if (price < 1000) {
      return LocaleKeys.priceWithCurrency.tr(namedArgs: {
        'price': price.toStringAsFixed(2),
      });
    }

    // ✅ بين 1000 و999999 → آلاف
    if (price < 1000000) {
      final thousandsValue = (price / 1000).toStringAsFixed(2);
      return LocaleKeys.thousands.tr(namedArgs: {
        'price': thousandsValue,
      });
    }

    // ✅ مليون فأكثر → ملايين
    final millionsValue = (price / 1000000).toStringAsFixed(2);
    return LocaleKeys.millionsAndHundredThousands.tr(namedArgs: {
      'price': millionsValue,
    });
  }
