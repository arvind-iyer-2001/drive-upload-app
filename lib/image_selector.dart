import 'package:image_picker/image_picker.dart';

class ImageSelector {
  final _picker = ImagePicker();
  Future<String> pickImageAndGetImagePath() async {
    PickedFile pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    final String filePath = pickedFile.path;
    return filePath;
  }

  Future<String> clickImageAndGetImagePath() async {
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.camera);

    final String filePath = pickedFile.path;
    return filePath;
  }
}
