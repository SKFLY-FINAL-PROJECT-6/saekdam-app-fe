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

  double originalWidth = 0;
  double originalHeight = 0;
  double displayWidth = 0;
  double displayHeight = 0;

  @override
  void initState() {
    super.initState();
    _loadImageSize();
  }

  Future<void> _loadImageSize() async {
    final imageFile = File(widget.image.path);
    final imageSize = await _getImageSize(imageFile);

    if (mounted) {
      setState(() {
        originalWidth = imageSize.width;
        originalHeight = imageSize.height;

        double screenWidth = MediaQuery.of(context).size.width * 0.8;
        double screenHeight = MediaQuery.of(context).size.height * 0.8;
        double aspectRatio = originalWidth / originalHeight;

        if (aspectRatio > 1) {
          displayWidth = screenWidth;
          displayHeight = screenWidth / aspectRatio;
        } else {
          displayHeight = screenHeight;
          displayWidth = screenHeight * aspectRatio;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (originalWidth == 0 || originalHeight == 0) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.5)),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(widget.image.path),
                width: displayWidth,
                height: displayHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
          _buildMaskingBox(),
          _buildTopBar(),
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
              double newWidth = rectWidth + details.delta.dx;
              double newHeight = rectHeight + details.delta.dy;

              // ✅ 크기 제한: 박스가 이미지 밖으로 나가지 않도록 설정
              if (newWidth > 50 && (rectLeft + newWidth) <= displayWidth) {
                rectWidth = newWidth;
              }
              if (newHeight > 50 && (rectTop + newHeight) <= displayHeight) {
                rectHeight = newHeight;
              }
            } else {
              double newLeft = rectLeft + details.delta.dx;
              double newTop = rectTop + details.delta.dy;

              // ✅ 이동 제한: 박스가 이미지 밖으로 이동하지 않도록 설정
              rectLeft = newLeft.clamp(0, displayWidth - rectWidth);
              rectTop = newTop.clamp(0, displayHeight - rectHeight);
            }
          });
        },
        child: Stack(
          children: [
            Container(
              width: rectWidth,
              height: rectHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanStart: (_) => isResizing = true,
                onPanEnd: (_) => isResizing = false,
                onPanUpdate: (details) {
                  double newWidth = rectWidth + details.delta.dx;
                  double newHeight = rectHeight + details.delta.dy;

                  // ✅ 크기 조절 제한 (이미지 내부 유지)
                  if (newWidth > 50 && (rectLeft + newWidth) <= displayWidth) {
                    setState(() => rectWidth = newWidth);
                  }
                  if (newHeight > 50 && (rectTop + newHeight) <= displayHeight) {
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
            icon: Icon(Icons.close, color: Colors.white, size: 30),
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text("완료", style: TextStyle(fontSize: 18, color: Colors.black)),
        ),
      ),
    );
  }

  Future<Size> _getImageSize(File imageFile) async {
    final image = await decodeImageFromList(imageFile.readAsBytesSync());
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  void _showPromptDialog() {
    Map<String, dynamic> maskData = getScaledCoordinates(
      originalWidth: originalWidth,
      originalHeight: originalHeight,
      displayWidth: displayWidth,
      displayHeight: displayHeight,
    );

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

  Map<String, dynamic> getScaledCoordinates({
    required double originalWidth,
    required double originalHeight,
    required double displayWidth,
    required double displayHeight,
  }) {
    double scaleX = originalWidth / displayWidth;
    double scaleY = originalHeight / displayHeight;

    return {
      "x": rectLeft * scaleX,
      "y": (displayHeight - (rectTop + rectHeight)) * scaleY, // ✅ 좌표 변환 (왼쪽 하단 기준)
      "width": rectWidth * scaleX,
      "height": rectHeight * scaleY
    };
  }
}
