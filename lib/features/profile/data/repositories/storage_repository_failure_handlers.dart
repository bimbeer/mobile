class ImageUploadFailure implements Exception {
  const ImageUploadFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  final String message;

  factory ImageUploadFailure.fromCode(String code) {
    switch (code) {
      case 'storage/server-file-wrong-size':
        return const ImageUploadFailure(
          'File was too large.',
        );
      default:
        return const ImageUploadFailure();
    }
  }
}