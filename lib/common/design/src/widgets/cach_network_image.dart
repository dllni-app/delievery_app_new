import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../../extensions/src/context_extensions.dart';
import '../../design.dart';

class CacheNetworkImage extends StatelessWidget {
  const CacheNetworkImage({
    super.key,
    this.border,
    this.borderRadius,
    this.width,
    this.height,
    required this.imageUrl,
    this.boxFit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
    this.blurHash
  });
  final double? width;
  final double? height;
  final String imageUrl;
  final BoxFit boxFit;
  final Border? border;
  final BoxShape shape;
  final BorderRadiusGeometry? borderRadius;
  final String? blurHash;
  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      imageUrl,
      width: width,
      height: height,
      fit: boxFit,
      cache: true,
      timeLimit: const Duration(seconds: 10),
      timeRetry: const Duration(seconds: 10),
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return blurHash==null?ShimmerWidget(
              width: width,
              height: height,
              shape: shape,
              border: border,
              borderRadius: borderRadius,
            ):
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                shape: shape,
                border: border,
                borderRadius: borderRadius,

              ),
              child: Image.network(blurHash!),
            );
          case LoadState.completed:
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                shape: shape,
                border: border,
                borderRadius: borderRadius,
                image: DecorationImage(
                  image: state.imageProvider,
                  fit: boxFit,
                ),
              ),
            );
          default:
            return GestureDetector(
              onTap: () {
                state.reLoadImage();
              },
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  shape: shape,
                  border: border,
                  borderRadius: borderRadius,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.replay_circle_filled_sharp,
                        color: context.primarySwatch,
                        size:width??  50,
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
      // child: CachedNetworkImage(
      //   imageUrl: imageUrl,
      //   placeholder: (context, _) => BlurHash(
      //     imageFit: boxFit,
      //     duration: const Duration(milliseconds: 1500),
      //     curve: Curves.linear,
      //     hash: hash ?? 'LHA-Vc_4s9ad4oMwt8t7RhXTNGRj',
      //     // image: imageUrl,
      //   ),
      //   errorWidget: (context, _, __) => BlurHash(
      //     imageFit: boxFit,
      //     duration: const Duration(milliseconds: 1500),
      //     curve: Curves.linear,
      //     hash: hash ?? 'LHA-Vc_4s9ad4oMwt8t7RhXTNGRj',
      //     // image: imageUrl,
      //   ),
      // ),
      //  BlurHash(
      //   imageFit: boxFit,
      //   duration: const Duration(milliseconds: 1500),
      //   curve: Curves.easeInBack,
      //   hash: hash ?? 'LHA-Vc_4s9ad4oMwt8t7RhXTNGRj',
      //   image: imageUrl,
      // ),
    );
  }
}
