/// Centralized asset paths so widgets never hardcode raw path strings.
class AssetPaths {
  AssetPaths._();

  static const String _imagesBase = 'assets/images';

  static const String logo = '$_imagesBase/logo.svg';
  static const String logoPng = '$_imagesBase/logo.png';
}
