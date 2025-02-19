import 'package:flutter/material.dart';
import 'package:fly_ai_1/api.dart';
import 'package:fly_ai_1/post.dart';
import 'package:fly_ai_1/screen/community.dart';

class PostPreview extends StatelessWidget {
  const PostPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: ApiService.fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("데이터를 불러오는 데 실패했습니다."));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("게시글이 없습니다."));
        }

        // 최신 2개 게시글만 가져오기
        final posts = snapshot.data!;
        final latestTwoPosts = posts.length >= 2 ? posts.take(2).toList() : posts;

        return Column(
          children: latestTwoPosts.map((post) {
            // 💡 여기서는 샘플 이미지를 사용. 이미지가 없는 경우 placeholder로 처리
            // UI는 주석 처리했던 카드 스타일로 작성
            return GestureDetector(
              onTap: () {
                // 카드 클릭 시 상세 페이지 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Community()),
                );
              },
              child: Container(
                height: 120,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      offset: const Offset(0, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // 왼쪽 미리보기 이미지 (예시)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: Image.asset(
                        'asset/img/image_1.jpg', // 임시 이미지
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // 오른쪽 정보
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 제목
                            Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // 내용 (미리보기)
                            Text(
                              post.content,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // 좋아요, 조회수 표시
                            Row(
                              children: [
                                const Icon(
                                  Icons.thumb_up_off_alt,
                                  color: Colors.pinkAccent,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text('${post.likes}'),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Color(0xFF6799FF),
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text('${post.views}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
