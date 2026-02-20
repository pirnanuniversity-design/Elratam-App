// dummy_image_picker.dart
class ImagePicker {
  Future<void> pickImage({source}) async {
    throw UnimplementedError("ImagePicker not supported on this platform.");
  }
}

enum ImageSource { gallery, camera }
