import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/utils/helpers/extension/string_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transparent_image/transparent_image.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    Key? key,
    this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius,
    this.color,
  }) : super(key: key);
  final String? url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        ((url?.isEmpty ?? false) || (url?.contains('string') ?? true))
            ? AssetConstants.logoGober
            : url!;
    final bool isSvg = imageUrl.contains('.svg');

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0.0),
      child:
          (imageUrl.indexOf('assets') == 0 || !imageUrl.contains('http'))
              ? (isSvg
                  ? imageUrl.toSvg(
                    width: width,
                    height: height,
                    context: context,
                    color: color,
                  )
                  : Image.asset(
                    imageUrl,
                    width: width,
                    height: height,
                    fit: fit,
                    color: color,
                    errorBuilder:
                        (context, error, stackTrace) => Image.asset(
                          AssetConstants.logoGober,
                          width: width,
                          height: height,
                          fit: fit,
                        ),
                  ))
              : (isSvg
                  ? SvgPicture.network(
                    imageUrl,
                    width: width,
                    height: height ?? width,
                    color: color,
                  )
                  : (kIsWeb
                      ? FadeInImage.memoryNetwork(
                        width: width,
                        height: height,
                        fit: fit,
                        image: imageUrl,
                        placeholder: kTransparentImage,
                      )
                      : CachedNetworkImage(
                        width: width,
                        height: height,
                        fit: fit,
                        imageUrl: imageUrl,
                        color: color,
                        errorWidget:
                            (context, url, error) => Image.asset(
                              AssetConstants.logoGober,
                              width: width,
                              height: height,
                              fit: fit,
                            ),
                      ))),
    );
  }
}
