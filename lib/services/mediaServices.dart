import 'package:file_picker/file_picker.dart';

class MediaServices {
  MediaServices();

  Future<PlatformFile?> pickfileFromLibary() async {
    FilePickerResult? _result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (_result != null) {
      return _result.files[0];
    } else {
      return null;
    }
  }
}
