import 'package:flutter/material.dart';
import '../../../../../common/design/src/theme/assets.gen.dart';
import '../../../../../common/design/src/theme/const.dart';
import '../../../../../common/design/src/widgets/svg_asset.dart';
import '../../../../../common/extensions/src/context_extensions.dart';

class HomeAppBarWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.only(top:context.statusBarHeight),
      decoration: BoxDecoration(
        boxShadow: [

          BoxShadow(
            offset: Offset(0,1),
            blurRadius: 2,
            color: Color.fromRGBO(0, 0, 0, .05),
            spreadRadius: 0
          )
        ],
        color: context.scaffoldBackgroundColor
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: SvgAsset(Assets.images.svg.home.drawerIcon,color: context.primarySwatch),
                  onPressed:  () => Scaffold.of(context).openDrawer(),
                ),
                Text(
                  "GT Express",
                  style: context.headlineLarge(
                      fontSize: 20,
                      fontFamily: AppFontFamily.workSans,
                      color: context.appBarColor
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),


              ],
            ),
          ),
          Space.vM2,
          Divider(height:1,color: context.dividerColor)
        ],
      ),
    );
    // return SliverAppBar(
    //   pinned: true,
    //   surfaceTintColor: Colors.transparent,
    //   foregroundColor: Colors.black,
    //   backgroundColor: Colors.white,
    //   automaticallyImplyLeading: false,
    //
    //   elevation: 0,
    //   flexibleSpace: SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           IconButton(
    //             icon: SvgAsset(Assets.images.svg.home.drawerIcon),
    //             onPressed:  () => Scaffold.of(context).openDrawer(),
    //           ),
    //           Text(
    //             "GT Express",
    //             style: context.headlineLarge(
    //               fontSize: 20,
    //               fontFamily: AppFontFamily.workSans,
    //               color: context.primarySwatch
    //             ),
    //             overflow: TextOverflow.ellipsis,
    //             maxLines: 1,
    //           ),
    //
    //         ],
    //       ),
    //     ),
    //   ),
    //   bottom: PreferredSize(
    //     preferredSize: const Size.fromHeight(1),
    //     child: Divider(
    //       height: 1,
    //       thickness: 1,
    //       color: context.dividerColor,
    //     ),
    //   ),
    //   expandedHeight: kToolbarHeight+10,
    //   collapsedHeight: kToolbarHeight+10,
    //   floating: false,
    //   snap: false,
    //   stretch: false,
    // );
  }
}
