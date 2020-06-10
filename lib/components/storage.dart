import 'dart:io';


Future<File> appendContent(File file, String data) async {
  return file.writeAsString(data, mode: FileMode.append);
}

Future<File> clearFile(File file) async {
  return file.writeAsString("", flush: true);
}

Future<List<String>> readContentsByLine(File file) async {
  try {
    List<String> contents = await file.readAsLines();
    return contents;
  } catch (e) {
    return [];
  }
}
