import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fly_ai_1/img_create/prompt_input_dialog.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

class MaskingScreen extends StatefulWidget {
  final XFile image;

  const MaskingScreen({required this.image, Key? key}) : super(key: key);

  @override
  _MaskingScreenState createState() => _MaskingScreenState();
}

class _MaskingScreenState extends State<MaskingScreen> {
  double rectLeft = 100;
  double rectTop = 200;
  double rectWidth = 200;
  double rectHeight = 300;
  bool isResizing = false;

  double originalWidth = 0;
  double originalHeight = 0;
  double displayWidth = 0;
  double displayHeight = 0;

  File? rotatedImageFile;
  GlobalKey imageContainerKey = GlobalKey(); // ✅ 이미지 컨테이너 크기 측정

  @override
  void initState() {
    super.initState();
    _loadImageSize();
  }

  Future<File> _getRotatedImage() async {
    return await FlutterExifRotation.rotateImage(path: widget.image.path);
  }

  Future<void> _loadImageSize() async {
    rotatedImageFile = await _getRotatedImage();
    final imageSize = await _getImageSize(rotatedImageFile!);

    if (mounted) {
      setState(() {
        originalWidth = imageSize.width;
        originalHeight = imageSize.height;
      });

      // ✅ 렌더링된 이미지 크기 가져오기
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderBox renderBox =
        imageContainerKey.currentContext!.findRenderObject() as RenderBox;
        setState(() {
          displayWidth = renderBox.size.width;
          displayHeight = renderBox.size.height;

          print("📸 원본 이미지 크기: ${originalWidth} x ${originalHeight}");
          print("📱 실제 표시되는 이미지 크기: ${displayWidth} x ${displayHeight}");
        });
      });
    }
  }

  Future<Size> _getImageSize(File imageFile) async {
    final image = await decodeImageFromList(imageFile.readAsBytesSync());
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    if (rotatedImageFile == null || originalWidth == 0 || originalHeight == 0) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              key: imageContainerKey, // ✅ 컨테이너 크기 추적
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  rotatedImageFile!,
                  fit: BoxFit.contain,
                ),
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
              // ✅ 크기 조절
              double newWidth = rectWidth + details.delta.dx;
              double newHeight = rectHeight + details.delta.dy;

              if (newWidth > 50 && (rectLeft + newWidth) <= displayWidth) {
                rectWidth = newWidth;
              }
              if (newHeight > 50 && (rectTop + newHeight) <= displayHeight) {
                rectHeight = newHeight;
              }

              print("📏 크기 조절 중: width=${rectWidth}, height=${rectHeight}");
            } else {
              // ✅ 이동
              double newLeft = rectLeft + details.delta.dx;
              double newTop = rectTop + details.delta.dy;

              rectLeft = newLeft.clamp(0, displayWidth - rectWidth);
              rectTop = newTop.clamp(0, displayHeight - rectHeight);

              print("📦 이동 중: x=${rectLeft}, y=${rectTop}");
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
                onPanStart: (_) => setState(() => isResizing = true),
                onPanEnd: (_) => setState(() => isResizing = false),
                onPanUpdate: (details) {
                  setState(() {
                    double newWidth = rectWidth + details.delta.dx;
                    double newHeight = rectHeight + details.delta.dy;

                    if (newWidth > 50 && (rectLeft + newWidth) <= displayWidth) {
                      rectWidth = newWidth;
                    }
                    if (newHeight > 50 && (rectTop + newHeight) <= displayHeight) {
                      rectHeight = newHeight;
                    }
                  });

                  print("🔄 크기 조절 중: width=${rectWidth}, height=${rectHeight}");
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

  void _showPromptDialog() {
    Map<String, dynamic> maskData = getScaledCoordinates();
    print("🟦 마스킹 박스 비율 좌표: $maskData");

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

  // ✅ 마스킹 박스 좌표를 이미지 내부 기준으로 변환
  Map<String, dynamic> getScaledCoordinates() {
    return {
      "x": (rectLeft / displayWidth) * originalWidth,
      "y": (rectTop / displayHeight) * originalHeight,
      "width": (rectWidth / displayWidth) * originalWidth,
      "height": (rectHeight / displayHeight) * originalHeight,
    };
  }
}
