import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fly_ai_1/img_create/prompt_input_dialog.dart';

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
      _showMyDialog();
    });
  }

  void _showMyDialog() {
    showDialog(
      // Dialog 바깥 부분을 눌러도 닫히지 않게 만듦
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PromptInputDialog();
      },
    );
  }

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
