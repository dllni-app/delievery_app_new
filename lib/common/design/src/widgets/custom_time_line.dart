import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../extensions/src/context_extensions.dart';
import '../theme/assets.gen.dart';
import '../theme/const.dart';
import 'cach_network_image.dart';
import 'svg_asset.dart';

class DeliveryTimeline extends StatelessWidget {
  final List<TimelineItem> items;

  const DeliveryTimeline({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(top: 24,bottom: 24,start: 12),

      child: FixedTimeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          indicatorPosition: -1,
          nodeItemOverlap: true,
          connectorTheme: const ConnectorThemeData(thickness: 2.5),
        ),
        builder: TimelineTileBuilder.connected(
          itemCount: items.length,
          indicatorBuilder: (context, index) {

            return DotIndicator(
              color: context.navBarSelectedColor,
              child: Container(
                padding: EdgeInsets.all(8),
                child: SvgAsset(
                  Assets.images.svg.product.check,
                  height: 20,
                  color: Colors.white,
                ),
              ),
            );
          },
          connectorBuilder: (context, index, type) {
            return SolidLineConnector(
              color: context.primarySwatch.withOpacity(.1),
            );
          },
          contentsBuilder: (context, index) {
            final item = items[index];

            return Container(
              padding: const EdgeInsetsDirectional.only(start: 18, bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.navBarSelectedColor.withOpacity(.1),
                    ),
                    child:item.pngImage==null?
                        Assets.images.png.logo.image(
                          width: 30,
                          height: 30,
                        )
                        : CacheNetworkImage(
                      imageUrl: item.pngImage!,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  Space.hS3,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          style: context.headlineSmall(
                            fontSize: 14,
                            color: context.navBarSelectedColor,
                          ),
                        ),
                        Text(
                          item.description,
                          style: context.bodyLarge(
                            color: context.hintColor,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          item.time,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TimelineItem {
  final String? pngImage;
  final String title;
  final String description;
  final String time;

  TimelineItem({
    required this.pngImage,
    required this.title,
    required this.description,
    required this.time,
  });
}
