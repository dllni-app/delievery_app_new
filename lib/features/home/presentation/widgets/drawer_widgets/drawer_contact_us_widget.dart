import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/design/src/theme/assets.gen.dart';
import '../../../../../common/design/src/widgets/animation_widget/animated_scale_widget.dart';
import '../../../../../common/design/src/widgets/animation_widget/animated_title_text_widget.dart';
import '../../../../../common/design/src/widgets/svg_asset.dart';
import '../../../../../common/extensions/src/context_extensions.dart';
import '../../../../../common/helper/src/locale_keys.dart';
import '../../../../../core/utils/app_colors.dart';

class DrawerContactUsWidget extends StatelessWidget {
  const DrawerContactUsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        crossAxisAlignment: .center,
        children: [
          AnimatedScaleWidget(
            child: SvgAsset(
              Assets.images.svg.contactUs.contactUsSvgrepoCom,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 10),
          AnimatedTitleTextWidget(
            child: Text(
              LocaleKeys.contactUs.tr(),
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      children: [
        ContactusElement(
          title: LocaleKeys.syriaOffice.tr(),
          svgImage: Assets.images.svg.contactUs.phone,
          onTap: () => makeCall('+963944440694'),
        ),
        ContactusElement(
          title: LocaleKeys.chinaOffice.tr(),
          svgImage: Assets.images.svg.contactUs.phone,
          onTap: () => makeCall('+8618688898165'),
        ),
        ContactusElement(
          title: LocaleKeys.whatsApp.tr(),
          svgImage: Assets.images.svg.contactUs.whatsApp,
          onTap: () => openWhatsApp(),
        ),
        ContactusElement(
          title: LocaleKeys.weChat.tr(),
          svgImage: Assets.images.svg.contactUs.weChat,
          onTap: () => openWeChat(),
        ),
      ],
    );
  }
}

class ContactusElement extends StatelessWidget {
  final String svgImage;
  final String title;
  final GestureTapCallback onTap;

  const ContactusElement({
    super.key,
    required this.svgImage,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            AnimatedScaleWidget(
              child: SvgAsset(svgImage, color: AppColors.primary),
            ),
            SizedBox(width: 10),
            AnimatedTitleTextWidget(
              child: Text(title, style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> makeCall(String phone) async {
  final Uri url = Uri.parse("tel:$phone");

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }
}

Future<void> openWeChat() async {
  final Uri url = Uri.parse("https://u.wechat.com/MLuGdJKY99SVi4o1yuRPKWI?s=4");

  await launchUrl(url, mode: LaunchMode.platformDefault);
}

Future<void> openWhatsApp() async {
  final Uri url = Uri.parse("https://wa.me/message/XAQJX65JTQQTB1?src=qr");

  await launchUrl(url, mode: LaunchMode.platformDefault);
}
