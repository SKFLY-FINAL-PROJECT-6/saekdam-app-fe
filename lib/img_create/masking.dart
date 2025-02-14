import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fly_ai_1/img_create/prompt_input_dialog.dart'; // ✅ 다이얼로그 파일 import

class MaskingScreen extends StatefulWidget {
  final XFile image; // 📌 카메라에서 받은 이미지

  const MaskingScreen({required this.image, Key? key}) : super(key: key);

  @override
  _MaskingScreenState createState() => _MaskingScreenState();
}

class _MaskingScreenState extends State<MaskingScreen> {
  double rectLeft = 100;
  double rectTop = 200;
  double rectWidth = 200;
  double rectHeight = 300;
  bool isResizing = false; // 크기 조절 모드

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ✅ 카메라 스타일의 검정 배경
      body: Stack(
        children: [
          // 📌 반투명한 검정 오버레이
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // 📌 중앙에 사진 미리보기 (카메라 스타일)
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // ✅ 사진을 살짝 둥글게
              child: Image.file(
                File(widget.image.path),
                width: MediaQuery.of(context).size.width * 0.8, // 화면의 80% 크기
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ✅ 직사각형 박스 (이동 및 크기 조절 가능)
          Positioned(
            left: rectLeft,
            top: rectTop,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  if (isResizing) {
                    // 크기 조절 모드
                    rectWidth += details.delta.dx;
                    rectHeight += details.delta.dy;
                  } else {
                    // 이동 모드
                    rectLeft += details.delta.dx;
                    rectTop += details.delta.dy;
                  }
                });
              },
              child: Stack(
                children: [
                  // ✅ 선택 박스
                  Container(
                    width: rectWidth,
                    height: rectHeight,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  // ✅ 오른쪽 아래 크기 조절 핸들
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onPanStart: (_) => setState(() => isResizing = true),
                      onPanEnd: (_) => setState(() => isResizing = false),
                      onPanUpdate: (details) {
                        setState(() {
                          rectWidth += details.delta.dx;
                          rectHeight += details.delta.dy;
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 📌 상단 UI (카메라 스타일)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 닫기 버튼 (X)
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // ✅ 하단 버튼 (완료 버튼)
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.8), // ✅ 반투명한 흰색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                _showPromptDialog();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text("완료", style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 다이얼로그 띄우기 (프롬프트 입력)
  void _showPromptDialog() {
    Map<String, dynamic> maskData = getScaledCoordinates(
      originalWidth: 1000, // 원본 이미지 크기 (예제)
      originalHeight: 800,
      targetWidth: 512,
      targetHeight: 512,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PromptInputDialog(
          imageFile: widget.image,
          maskData: maskData, // ✅ 변환된 좌표 전달
        );
      },
    );
  }

  // ✅ 비율 맞춰 좌표 변환
  Map<String, dynamic> getScaledCoordinates({
    required double originalWidth,
    required double originalHeight,
    required double targetWidth,
    required double targetHeight,
  }) {
    double scaleX = targetWidth / originalWidth;
    double scaleY = targetHeight / originalHeight;

    return {
      "x": rectLeft * scaleX,
      "y": rectTop * scaleY,
      "width": rectWidth * scaleX,
      "height": rectHeight * scaleY
    };
  }
}
