import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fly_ai_1/img_create/prompt_input_dialog.dart';
import 'package:fly_ai_1/img_create/masking.dart'; // ✅ 벽 마스킹 파일 import

// 화면 로딩 시 바로 showDialog를 실행하기 위해 statefulWidget으로 선언
class PromptInputScreen extends StatefulWidget {
  XFile? image;

  PromptInputScreen({this.image, super.key});

  @override
  State<PromptInputScreen> createState() => _PromptInputScreenState();
}

// TODO : 뒤로가기를 누를 시에 대한 작동(HomeScreen으로 돌아가기) 구현하기기
class _PromptInputScreenState extends State<PromptInputScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _goToMaskingScreen();
    });
  }
    void _goToMaskingScreen(){
      if (widget.image != null){
        Navigator.push(

          context,
          MaterialPageRoute(builder: (context) => MaskingScreen(image: widget.image!),
          ),
        );
    }}


//  void _showMyDialog() {
//    showDialog(
//      barrierDismissible: false,
//     context: context,
//      builder: (context) {
//        return PromptInputDialog(imageFile: widget.image); // ✅ 이미지 전달
//      },
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: widget.image != null
            ? Image.file(File(widget.image!.path))
            : Text('이미지 없음'),
      ),
    );
  }
}
