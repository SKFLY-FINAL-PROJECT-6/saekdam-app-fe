import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fly_ai_1/constant/color.dart';
import 'package:fly_ai_1/screen/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // GIF 이미지 표시
          Positioned(
            top: 200, // 화면 상단에서 180px 아래
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                "asset/img/splash_screen_색담.gif",
                width: 270, // GIF 크기 조정
                height: 270,
                fit: BoxFit.cover,
              ).animate(),
            ),
          ),

          // 예상 소요 시간 + 홈 화면 이동 버튼 (하단)
          Positioned(
            bottom: 80, // 하단에서 50px 위
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Column 크기를 최소화하여 정렬 유지
                children: [
                  // 예상 소요 시간 텍스트
                  Text(
                    "예상 소요 시간: 약 3분", // 원하는 소요 시간 설정
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700], // 약간 어두운 색상 적용
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10), // 버튼과 간격 조절

                  // 홈 화면으로 이동 버튼
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%
                    height: 52, // 버튼 높이 52로 고정
                    child: ElevatedButton(
                      onPressed: () {
                        // HomeScreen으로 이동
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pinkmain, // 버튼 색상
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "홈 화면으로 이동",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



///상태에 따라 바뀌는 코드
/*enum TaskProgress {
  waiting,
  inProgress,
  completed,
  failed,
}

class SplashScreen extends StatelessWidget {
  final TaskProgress taskProgress; // 백엔드에서 전달받은 상태

  const SplashScreen({super.key, required this.taskProgress});

  // 상태에 따른 GIF 경로 반환
  String _getGifPath() {
    switch (taskProgress) {
      case TaskProgress.waiting:
        return "asset/img/waiting.gif";
      case TaskProgress.inProgress:
        return "asset/img/in_progress.gif";
      case TaskProgress.completed:
        return "asset/img/completed.gif";
      case TaskProgress.failed:
        return "asset/img/failed.gif";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 상태에 따른 GIF 이미지 표시
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                _getGifPath(), // 상태에 따른 경로 사용
                width: 270,
                height: 270,
                fit: BoxFit.cover,
              ).animate(),
            ),
          ),

          // 하단의 예상 소요 시간과 홈 화면 이동 버튼
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "예상 소요 시간: 약 3분",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        // HomeScreen으로 이동
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pinkmain,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "홈 화면으로 이동",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
