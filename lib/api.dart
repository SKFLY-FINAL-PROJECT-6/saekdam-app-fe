import 'dart:io';
import 'package:path_provider/path_provider.dart';

// 📌 내부 저장소 경로 가져오기
Future<String> getLocalStoragePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// 📌 이미지 저장 (갤러리에서 선택한 이미지를 내부 저장소로 복사)
Future<String> saveImageToLocalDirectory(File imageFile) async {
  final String directoryPath = await getLocalStoragePath();
  final String filePath = '$directoryPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

  final File newImage = await imageFile.copy(filePath);
  return newImage.path; // 저장된 이미지 경로 반환
}

// 📌 저장된 이미지 불러오기
Future<List<String>> loadImagesFromLocalStorage() async {
  final String directoryPath = await getLocalStoragePath();
  final directory = Directory(directoryPath);

  if (!directory.existsSync()) {
    return []; // 폴더가 없으면 빈 리스트 반환
  }

  final List<FileSystemEntity> files = directory.listSync();
  return files
      .whereType<File>() // 파일만 필터링
      .map((file) => file.path) // 파일 경로 리스트로 변환
      .toList();
}
