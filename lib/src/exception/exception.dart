class NotModEntityException implements Exception {
  final String message;

  NotModEntityException(this.message);

  @override
  String toString() {
    return message;
  }

  static get notZipExtension =>
      NotModEntityException("Not supported file type");
  static get unknown => NotModEntityException("Unknown error");
  static get notFoundManifestFile =>
      NotModEntityException("Manifest file not found");
}