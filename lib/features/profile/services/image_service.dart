import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(ImageSource source) async {
  final image = await ImagePicker().pickImage(source: source);
  if (image == null) {
    return null;
  }
  File? img = File(image.path);
  img = await _cropImage(imageFile: img);
  return img;
}

Future<File?> _cropImage({required File imageFile}) async {
  CroppedFile? croppedImage =
      await ImageCropper().cropImage(sourcePath: imageFile.path);
  if (croppedImage == null) return null;
  return File(croppedImage.path);
}

Future<bool> validateImage(String imageUrl) async {
  http.Response res;
  try {
    res = await http.get(Uri.parse(imageUrl));
  } catch (e) {
    return false;
  }

  if (res.statusCode != 200) return false;
  Map<String, dynamic> data = res.headers;
  return checkIfImage(data['content-type']);
}

bool checkIfImage(String param) {
  if (param == 'image/jpeg' || param == 'image/png' || param == 'image/gif') {
    return true;
  }
  return false;
}
