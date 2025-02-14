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
            top: 180,   // 화면 상단에서 200px 아래
            left: 55,   // 화면 왼쪽에서 35px 오른쪽
            child: Image.asset(
              "asset/img/splash_screen_색담.gif",
              width: 350, // GIF 크기 조정
              height: 350,
              fit: BoxFit.cover,
            ).animate(),
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