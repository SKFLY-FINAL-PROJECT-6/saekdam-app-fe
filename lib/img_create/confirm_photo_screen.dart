/*

이제 사용하지 않을 예정
image_picker의 카메라/갤러리 기능을 이용하여 벽화 사진을 가져오도록 할 예정

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fly_ai_1/img_create/prompt_input_dialog.dart';
// import 'package:image_picker/image_picker.dart'; // XFile 사용
import 'dart:io';

import 'package:fly_ai_1/img_create/prompt_input_screen.dart'; // File 사용

class ConfirmPhotoScreen extends StatelessWidget {
  List<XFile> imageFiles; // XFile 리스트 받기

  ConfirmPhotoScreen({required this.imageFiles, super.key});

  @override
  Widget build(BuildContext context) {
    // PopScope는 뒤로가기를 직접 제어하기 위한 위젯
    return PopScope(
      /*
      canPop을 false로 해두면 뒤로가기가 금지됨
      canPop에 true 옵션을 준 뒤 Navigator.pop()까지 해버리면 이중 pop 문제가 발생.
      그러므로 뒤로가기를 눌렀을 때 특정 작업을 하고싶다면 canPop에 false를 준 뒤 onPopInvokedWithResult에서 수동으로 pop을 제어하는게 좋음
      */
      canPop: false,
      // 뒤로가기 시 실행되는 메소드
      // canPop이 true이든 false이든 onPop InvokedWithResult는 반드시 실행됨.
      // didPop은 canPop의 값을 가져옴(bool)
      onPopInvokedWithResult: (didPop, result) async {
        // 뒤로가기를 누를 시에도 사진을 다시 촬영하도록 함
        imageFiles = [];
        Navigator.pop(context, []);
      },
      child: Scaffold(
        appBar: AppBar(title: Text('사진 확인')),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: imageFiles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    // XFile → File 변환
                    child: Image.file(
                      File(imageFiles[index].path),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 50,
                      // TODO
                      // [x]: 뒤로가기 버튼을 눌렀을 때의 동작도 정해야함(사진을 다시 찍게 하던가, 아예 뒤로가기를 막던가) - 해결
                      child: ElevatedButton(
                        onPressed: () {
                          // 이미지 리스트 초기화
                          imageFiles = [];
                          // print('====================출력출력출력출력출력onPressed출력출력출력=======================');

                          Navigator.pop(context, []);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          // 테두리 속성
                          // side: BorderSide(
                          //   color: Colors.black,
                          //   width: 1.0,
                          // ),
                        ),
                        child: Text('다시 촬영'),
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (_) => PromptInputScreen(
                          //       imageFiles: imageFiles,
                          //     ),
                          //   ),
                          // );
                          // Navigator.pop(context, imageFiles);

                          showDialog(
                            // Dialog 바깥 부분을 눌러도 닫히지 않게 만듦
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return PromptInputDialog();
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(255, 127, 189, 1.0),
                          foregroundColor: Colors.white,
                        ),
                        child: Text('확인'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
