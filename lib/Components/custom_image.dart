import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/Components/custom_loading.dart';
import 'package:flutter_starter_kit/Global/Models/image_source.dart';

/// A versatile widget for displaying images from different sources (network, asset, or file).
/// For network images it implements CachedNetworkImage and shows the appropriate ui for loading, error, and success.
class CustomImage extends StatelessWidget {
  /// Pre-defined model to determine the source of the image (network, asset, or file).
  final ImageSource imageSource;

  /// The size of the image to display (width and height).
  final Size size;

  /// The shape of the image (rectangle or circle).
  final BoxShape shape;

  /// How the image should be fitted within its container.
  final BoxFit? boxFit;

  /// Horizontal alignment of the image.
  final MainAxisAlignment mainAxisAlignment;

  /// Background color of the container.
  final Color? color;

  const CustomImage({
    super.key,
    required this.imageSource,
    required this.size,
    this.shape = BoxShape.rectangle,
    this.boxFit,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.color,
  });

  /// Helper method to build the preview of the image, including its decoration and size.
  /// Takes an optional [imageProvider] to define the actual image content.
  Widget _preview(
    BuildContext context, {
    ImageProvider? imageProvider,
    Widget? child,
  }) {
    //! Wrapped with row so that width takes effect when widget is used in listview or column
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).highlightColor,
            shape: shape,
            image: imageProvider == null
                ? null
                : DecorationImage(
                    image: imageProvider,
                    fit: boxFit,
                  ),
          ),
          child:
              child, // Optionally display child (e.g., a loader or error icon).
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Switches between different image types (network, asset, file) based on the ImageSource.
    switch (imageSource.imageType) {
      // Case for displaying a network image.
      case ImageType.network:
        final url = imageSource.networkUrl;
        return CachedNetworkImage(
          imageUrl: url!,
          imageBuilder: (context, imageProvider) {
            // Once the image is successfully loaded, display it.
            return _preview(context, imageProvider: imageProvider);
          },
          placeholder: (context, url) {
            // Display a loading indicator while the image is being fetched.
            return _preview(
              context,
              child: Center(
                child: CustomLoading(size: min(size.width, size.height) / 2),
              ),
            );
          },
          errorWidget: (context, url, error) {
            // Display an error icon if the image fails to load.
            return _preview(
              context,
              child: Icon(
                Icons.error,
                size: min(size.width, size.height) * 0.3,
                color: Theme.of(context).colorScheme.error,
              ),
            );
          },
        );

      // Case for displaying an asset image (from the local bundle).
      case ImageType.asset:
        final assetPath = imageSource.assetPath;
        return _preview(
          context,
          imageProvider: AssetImage(assetPath!),
        );

      // Case for displaying a file image (from the local file system).
      case ImageType.file:
        final file = imageSource.file;
        return _preview(
          context,
          imageProvider: FileImage(file!),
        );

      // Fallback for invalid or unspecified image sources.
      default:
        return _preview(
            context); // Return an empty container if no valid image source is provided.
    }
  }
}
