import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:fly_ai_1/img_create/prompt_input_dialog.dart'; // ✅ 다이얼로그 파일 import

class MaskingScreen extends StatefulWidget {
  final XFile image; // 📌 카메라에서 받은 이미지

  const MaskingScreen({required this.image, Key? key}) : super(key: key);

  @override
  _MaskingScreenState createState() => _MaskingScreenState();
}

class _MaskingScreenState extends State<MaskingScreen> {
  // 마스킹 박스 초기값
  double rectLeft = 0;
  double rectTop = 0;
  double rectWidth = 200;   // 시작 크기 (임의)
  double rectHeight = 200;  // 시작 크기 (임의)
  bool isResizing = false;

  double originalWidth = 0;
  double originalHeight = 0;
  double displayWidth = 0;
  double displayHeight = 0;

  File? rotatedImageFile;

  @override
  void initState() {
    super.initState();
    _loadImageSize();
  }

  // EXIF 정보를 반영하여 이미지를 올바른 방향으로 회전시킨 파일 반환
  Future<File> _getRotatedImage() async {
    return await FlutterExifRotation.rotateImage(path: widget.image.path);
  }

  // 이미지 크기 불러오기
  Future<void> _loadImageSize() async {
    rotatedImageFile = await _getRotatedImage();
    final imageSize = await _getImageSize(rotatedImageFile!);

    if (mounted) {
      setState(() {
        originalWidth = imageSize.width;
        originalHeight = imageSize.height;

        // 화면 80% 범위 내에서 이미지 표시 크기 결정
        final screenWidth = MediaQuery.of(context).size.width * 1;
        final screenHeight = MediaQuery.of(context).size.height * 0.74;
        final aspectRatio = originalWidth / originalHeight;

        if (aspectRatio > 1) {
          // 가로가 더 긴 경우
          displayWidth = screenWidth;
          displayHeight = screenWidth / aspectRatio;
        } else {
          // 세로가 더 긴 경우
          displayHeight = screenHeight;
          displayWidth = screenHeight * aspectRatio;
        }

        // 마스킹 박스를 이미지 내부로 초기 배치 (왼쪽 상단 100x100 정도)
        rectLeft = 0;
        rectTop = 0;
        rectWidth = 200;
        rectHeight = 200;
      });
    }
  }

  // 이미지 파일의 실제 크기 구하기
  Future<Size> _getImageSize(File imageFile) async {
    final image = await decodeImageFromList(imageFile.readAsBytesSync());
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    if (rotatedImageFile == null ||
        originalWidth == 0 ||
        originalHeight == 0) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // --- (1) 이미지와 마스킹 박스를 "왼쪽 상단 정렬"로 배치 ---
          Positioned(
            left: 0,
            top: 100,
            child: Container(
              width: displayWidth,
              height: displayHeight,
              color: Colors.black, // 이미지 주변 배경색
              child: Stack(
                children: [
                  // 실제 이미지
                  Image.file(
                    rotatedImageFile!,
                    width: displayWidth,
                    height: displayHeight,
                    fit: BoxFit.contain,
                  ),
                  // 마스킹 박스
                  _buildMaskingBox(),
                ],
              ),
            ),
          ),
          // --- (2) 상단 닫기 버튼 ---
          _buildTopBar(),
          // --- (3) 하단 완료 버튼 ---
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildMaskingBox() {
    return Positioned(
      left: rectLeft,
      top: rectTop,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            if (isResizing) {
              // 크기 조절 모드
              double newWidth = rectWidth + details.delta.dx;
              double newHeight = rectHeight + details.delta.dy;

              // 최소 0 이상, 최대 이미지 범위 내
              if (newWidth >= 1 && (rectLeft + newWidth) <= displayWidth) {
                rectWidth = newWidth;
              }
              if (newHeight >= 1 && (rectTop + newHeight) <= displayHeight) {
                rectHeight = newHeight;
              }
            } else {
              // 이동 모드
              double newLeft = rectLeft + details.delta.dx;
              double newTop = rectTop + details.delta.dy;

              // 이미지 영역 벗어나지 않게 clamp
              if (newLeft < 0) newLeft = 0;
              if (newTop < 0) newTop = 0;
              if (newLeft + rectWidth > displayWidth) {
                newLeft = displayWidth - rectWidth;
              }
              if (newTop + rectHeight > displayHeight) {
                newTop = displayHeight - rectHeight;
              }

              rectLeft = newLeft;
              rectTop = newTop;
            }
          });
        },
        child: Stack(
          children: [
            // 마스킹 박스
            Container(
              width: rectWidth,
              height: rectHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            // 오른쪽 하단 크기 조절 핸들
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanStart: (_) => isResizing = true,
                onPanEnd: (_) => isResizing = false,
                onPanUpdate: (details) {
                  double newWidth = rectWidth + details.delta.dx;
                  double newHeight = rectHeight + details.delta.dy;

                  if (newWidth >= 1 && (rectLeft + newWidth) <= displayWidth) {
                    setState(() => rectWidth = newWidth);
                  }
                  if (newHeight >= 1 && (rectTop + newHeight) <= displayHeight) {
                    setState(() => rectHeight = newHeight);
                  }
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
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Positioned(
      bottom: 50,
      left: 20,
      right: 20,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: _showPromptDialog,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text("완료", style: TextStyle(fontSize: 18, color: Colors.black)),
        ),
      ),
    );
  }

  void _showPromptDialog() {
    // 원본 좌표로 변환된 maskData 생성
    final Map<String, dynamic> maskData = getScaledCoordinates();
    print("maskData: $maskData"); // 좌표값 콘솔 출력
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PromptInputDialog(
          imageFile: widget.image,
          maskData: maskData,
        );
      },
    );
  }

  // --- (4) 좌표 변환: 현재 (0,0)이 "이미지의 왼쪽 상단" ---
  Map<String, dynamic> getScaledCoordinates() {
    return {
      "x": rectLeft / displayWidth,
      "y": rectTop / displayHeight,
      "width": rectWidth / displayWidth,
      "height": rectHeight / displayHeight,
    };
  }

}
