import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_starter_kit/Components/custom_loading.dart';
import 'package:flutter_starter_kit/Global/enums.dart';

class CircularImage extends StatelessWidget {
  final ImageType imageType;
  final String path;
  final double radius;
  final BoxFit? boxFit;

  const CircularImage({
    super.key,
    required this.imageType,
    required this.path,
    required this.radius,
    this.boxFit = BoxFit.cover,
  });

  Widget _preview(
    BuildContext context, {
    ImageProvider? imageProvider,
    Widget? child,
  }) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        shape: BoxShape.circle,
        image: imageProvider == null
            ? null
            : DecorationImage(
                image: imageProvider,
                fit: boxFit,
              ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (imageType) {
      case (ImageType.networkImage):
        return CachedNetworkImage(
          imageUrl: path,
          imageBuilder: (context, imageProvider) {
            return _preview(context, imageProvider: imageProvider);
          },
          placeholder: (context, url) {
            return _preview(
              context,
              child: Center(
                child: CustomLoading(
                  size: radius,
                ),
              ),
            );
          },
          errorWidget: (context, url, error) {
            return _preview(
              context,
              child: Icon(
                Icons.error,
                size: radius * 0.6,
                color: Theme.of(context).colorScheme.error,
              ),
            );
          },
        );
      default:
        return _preview(
          context,
          imageProvider: AssetImage(path),
        );
    }
  }
}
