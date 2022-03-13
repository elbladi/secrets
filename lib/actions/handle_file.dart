import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<String> getFilePath(bool isFromAssets) async {
  try {
    if (isFromAssets) return "assets/";
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final myPath = appDocumentsDirectory.path + "/assets/";
    Directory dir = Directory(myPath);
    if (!await dir.exists()) {
      await dir.create();
    }
    return dir.path;
  } catch (e) {
    rethrow;
  }
}

Future<String> moveFile(File image, String name) async {
  final newPath = await getFilePath(false);
  try {
    final file2Move = changeFileNameOnlySync(image, name);
    final extension = p.extension(file2Move.path);
    await file2Move.copy(newPath + name + extension);
    await file2Move.delete();
    return newPath + name + extension;
  } catch (e) {
    rethrow;
  }
}

File changeFileNameOnlySync(File file, String newFileName) {
  var path = file.path;
  final extension = p.extension(path);
  var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
  var newPath = path.substring(0, lastSeparator + 1) + newFileName + extension;
  return file.renameSync(newPath);
}

Future<void> deleteFile(String path) async {
  try {
    File file = File(path);
    await file.delete();
  } catch (e) {
    rethrow;
  }
}

void logError(Object error) {}
