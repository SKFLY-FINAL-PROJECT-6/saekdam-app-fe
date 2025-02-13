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
  List<Offset> points = []; // 📌 사용자가 터치한 꼭짓점 저장
  bool isErasing = false; // 📌 지우개 모드 ON/OFF

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

          // 📌 벽을 선택할 수 있도록 마스킹 기능 추가
          GestureDetector(
            onTapDown: (details) {
              RenderBox? renderBox = context.findRenderObject() as RenderBox?;
              if (renderBox != null) {
                Offset localPosition = details.localPosition;

                // ✅ 이미지의 위치와 크기 계산
                double imageWidth = MediaQuery.of(context).size.width * 0.8;
                double imageHeight = imageWidth * (File(widget.image.path).lengthSync() / imageWidth); // 비율 유지

                Rect imageRect = Rect.fromCenter(
                  center: Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2),
                  width: imageWidth,
                  height: imageHeight,
                );

                // ✅ 터치한 위치가 이미지 안에 있을 때만 추가
                if (imageRect.contains(localPosition)) {
                  setState(() {
                    if (isErasing) {
                      points.removeWhere((point) => (point - localPosition).distance < 20);
                    } else {
                      points.add(localPosition);
                    }
                  });
                }
              }
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: WallSelectionPainter(points),
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
                // 지우개 모드 버튼
                IconButton(
                  icon: Icon(
                      isErasing ? Icons.pan_tool_alt : Icons.auto_fix_normal,
                      color: Colors.white,
                      size: 30),
                  onPressed: () {
                    setState(() {
                      isErasing = !isErasing;
                    });
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
                if (points.isNotEmpty) {
                  _showPromptDialog();
                } else {
                  // ✅ 벽을 선택하지 않았을 때 경고창 띄우기
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("알림"),
                        content: Text("벽을 선택해주세요!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("확인"),
                          ),
                        ],
                      );
                    },
                  );
                }
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PromptInputDialog(
          imageFile: widget.image,
          maskPoints: points, // ✅ 꼭짓점 좌표 전달
        );
      },
    );
  }
}

// ✅ 꼭짓점만 저장하고 UI에서 선을 이어서 보이게 하는 `WallSelectionPainter`
class WallSelectionPainter extends CustomPainter {
  final List<Offset> points;

  WallSelectionPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black//  반투명 검은색
      ..style = PaintingStyle.stroke //  선을 그리는 스타일
      ..strokeWidth = 2.5 //  선 두께 조절
      ..strokeCap = StrokeCap.round; //  선 끝을 둥글게 처리

    Path path = Path();

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy); //  첫 좌표에서 시작
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy); //  꼭짓점을 이어줌
      }
    }

    canvas.drawPath(path, paint); //  UI에서 선으로 보이게 하기
    for (var point in points) {
      canvas.drawCircle(point, 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
