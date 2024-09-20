import 'dart:io';

/// Enum to represent different types of image sources.
enum ImageType {
  network,
  asset,
  file,
}

/// Base class for representing different types of image sources.
abstract class ImageSource {
  const ImageSource();

  // Factory constructors to create instances of ImageSource
  const factory ImageSource.asset(String assetPath) = _AssetImageSource;
  const factory ImageSource.network(String url) = _NetworkImageSource;
  const factory ImageSource.file(File file) = _FileImageSource;

  // Type checker to determine the source type
  ImageType get imageType;

  // Expose relevant properties
  String? get assetPath => null;
  String? get networkUrl => null;
  File? get file => null;
}

// Private subclass for asset images
class _AssetImageSource extends ImageSource {
  final String _path;
  const _AssetImageSource(this._path);

  @override
  ImageType get imageType => ImageType.asset;

  @override
  String? get assetPath => _path;
}

// Private subclass for network images
class _NetworkImageSource extends ImageSource {
  final String _url;
  const _NetworkImageSource(this._url);

  @override
  ImageType get imageType => ImageType.network;

  @override
  String? get networkUrl => _url;
}

// Private subclass for file-based images
class _FileImageSource extends ImageSource {
  final File _file;
  const _FileImageSource(this._file);

  @override
  ImageType get imageType => ImageType.file;

  @override
  File? get file => _file;
}
