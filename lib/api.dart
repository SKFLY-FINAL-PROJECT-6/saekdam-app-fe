import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post.dart';
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
      .where((file) => file.lengthSync() > 0) // 🔥 빈 파일 제거
      .map((file) => file.path) // 파일 경로 리스트로 변환
      .toList();
}

class ApiService {
  static const String baseUrl = "https://saekdam.kro.kr/api";

  // 📌 여러 개의 썸네일 ID를 한 번에 URL로 변환 (POST 요청)
  static Future<List<String>?> getThumbnailUrls(List<String> thumbnailIds) async {
    final String url = "$baseUrl/storage/accessUrls";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',  // JSON 요청
        },
        body: jsonEncode(thumbnailIds),  // 📌 리스트 형태로 변환하여 전송
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse.cast<String>(); // 🔹 JSON 리스트를 String 리스트로 변환
      } else {
        print("❌ 썸네일 요청 실패: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ 썸네일 요청 중 오류: $e");
      return null;
    }
  }

  // 📌 게시글 목록 불러오기 (썸네일 URL 포함)
  static Future<List<Post>> fetchPosts() async {
    final String url = "$baseUrl/posts";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonResponse = json.decode(responseBody);
        final List<dynamic> postsJson = jsonResponse['content'];

        // 모든 게시글의 썸네일 ID 리스트 추출
        List<String> thumbnailIds = postsJson
            .map((json) => json['thumbnail'] as String? ?? "") // ❗ null이면 빈 문자열("")로 유지
            .toList();

        // 📌 서버에서 썸네일 URL 리스트 가져오기 (POST 요청)
        List<String>? thumbnailUrls = await getThumbnailUrls(thumbnailIds);

        // 📌 Post 객체 생성 (썸네일 URL 추가)
        List<Post> posts = [];
        for (int i = 0; i < postsJson.length; i++) {
          posts.add(Post.fromJson(postsJson[i],
              thumbnailUrl: thumbnailUrls != null && i < thumbnailUrls.length
                  ? thumbnailUrls[i]
                  : null));
        }

        return posts;
      } else {
        throw Exception("게시글 데이터를 불러오는데 실패했습니다.");
      }
    } catch (e) {
      throw Exception("API 요청 실패: $e");
    }
  }
}
