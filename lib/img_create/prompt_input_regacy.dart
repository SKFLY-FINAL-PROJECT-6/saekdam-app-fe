/*

이제 사용하지 않을 예정
모달의 페이징을 제작하면서 구조가 너무 크게 바뀌었음

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class PromptInputRegacy extends StatelessWidget {
  List<XFile> imageFiles;

  PromptInputRegacy({required this.imageFiles, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // 빈 화면 탭 시 키보드 내리기
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.all(30.0),
          color: Colors.white,
          child: Center(
            child: ListView(
              // 높이 계산 오류 방지
              shrinkWrap: true,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: imageFiles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                            File(imageFiles[index].path)), // XFile → File 변환
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text('프롬포트 입력'),
                SizedBox(
                  height: 5.0,
                ),
                SizedBox(
                  height: 240.0,
                  child: TextFormField(
                    // TextField, TextFormField의 InputDecoration 속성 정리리
                    // https://velog.io/@mm723/%ED%97%B7%EA%B0%88%EB%A6%AC%EB%8A%94-textfield-decoration-%EC%A0%95%EB%A6%AC
                    decoration: InputDecoration(
                      labelText: 'Prompt',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 31, 31, 31),
                      ),
                      fillColor: Colors.white,
                      // hoverColor: Color.fromRGBO(137, 220, 224, 1.0),
                      // focusColor: Color.fromRGBO(137, 220, 224, 1.0),
                      // 포커스 됐을 때 색 변경
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(137, 220, 224, 1.0),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    // 커서의 설정을 변경
                    cursorColor: const Color.fromARGB(255, 31, 31, 31),
                    validator: (val) {
                      if (val?.length == 0) {
                        return '프롬프트를 입력해주세요!';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.multiline,
                    // 텍스트를 상단 정렬
                    textAlignVertical: TextAlignVertical.top,
                    // expands : TextFormField의 크기를 공간의 최대치로 고정하는 옵션
                    // expands의 값이 true라면 maxLines와 minLines는 무조건 null로 설정해야함
                    // expands: true,
                    // 자동 줄바꿈 허용
                    maxLines: null,
                    // 최소 1줄 보이도록 설정(default값 : 1, minLines > 0)
                    minLines: 2,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

*/
