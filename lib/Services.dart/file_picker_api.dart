import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilePickerAPI {
  FilePicker? filePicker;

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }
    return result!.files.first;
  }
}
