import 'dart:io';

/// Enum to represent different types of image sources.
enum ImageType {
  network,
  asset,
  file,
}

/// Base class for representing different types of image sources.
abstract class ImageModel {
  const ImageModel();

  // Factory constructors to create instances of ImageModel
  const factory ImageModel.asset(String assetPath) = _AssetImageModel;
  const factory ImageModel.network(String url) = _NetworkImageModel;
  const factory ImageModel.file(File file) = _FileImageModel;

  // Type checker to determine the source type
  ImageType get imageType;

  // Expose relevant properties
  String? get assetPath => null;
  String? get networkUrl => null;
  File? get file => null;
}

// Private subclass for asset images
class _AssetImageModel extends ImageModel {
  final String _path;
  const _AssetImageModel(this._path);

  @override
  ImageType get imageType => ImageType.asset;

  @override
  String? get assetPath => _path;
}

// Private subclass for network images
class _NetworkImageModel extends ImageModel {
  final String _url;
  const _NetworkImageModel(this._url);

  @override
  ImageType get imageType => ImageType.network;

  @override
  String? get networkUrl => _url;
}

// Private subclass for file-based images
class _FileImageModel extends ImageModel {
  final File _file;
  const _FileImageModel(this._file);

  @override
  ImageType get imageType => ImageType.file;

  @override
  File? get file => _file;
}
