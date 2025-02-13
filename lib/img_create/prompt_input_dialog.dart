import 'package:flutter/material.dart';
import 'package:fly_ai_1/img_create/button/tag_toggle_button_widget.dart';
import 'package:fly_ai_1/screen/home_screen.dart';
import 'package:camera/camera.dart'; // ✅ 여기에 추가!
import 'dart:io'; // ✅ File을 사용하려면 필요함!

class PromptInputDialog extends StatefulWidget {
  final XFile? imageFile; // ✅ 전달받은 이미지 파일
  final List<Offset> maskPoints;
  const PromptInputDialog({Key? key, required this.imageFile, required this.maskPoints}) : super(key: key);

  @override
  State<PromptInputDialog> createState() => _PromptInputDialogState();
}


class _PromptInputDialogState extends State<PromptInputDialog> {
  int stepIndex = 0;
  TextEditingController promptController = TextEditingController();
  File? savedImage; // ✅ 저장할 이미지 변수

  Map<String, String?> data = {
    "theme": null,  // 1단계: 메인 테마
    "mood": null,   // 2단계: 분위기
    "color": null,  // 3단계: 메인 컬러
    "request": null // 4단계: 추가 요청 사항
  };
  final List<String> stepPromptDescription = [
    '원하는 메인 테마를 선택해주세요.',
    '원하는 분위기를 선택해주세요.',
    '원하는 컬러를 선택해주세요.',
    '추가 요청 사항을 작성해주세요.',
  ];

  final List<String> stepPromptTitles = [
    '메인 테마',
    '분위기',
    '메인 컬러',
    '',
  ];

  List<String?> selectedKeywords = [null, null, null, null];

  void _nextStep() {

    if (stepIndex < 3) { // ✅ 0~2단계 (키워드 선택)
      if ((stepIndex == 0 && data['theme'] != null) ||
          (stepIndex == 1 && data['mood'] != null) ||
          (stepIndex == 2 && data['color'] != null)) {
        setState(() {
          stepIndex++;
        });
      } else {
        print("키워드를 선택해주세요!");

      }
    } else if (stepIndex == 3) { // ✅ 4단계 (텍스트 입력)
      if (promptController.text.isNotEmpty) {
        setState(() {
          data['request'] = promptController.text;
        });

        print("최종 선택된 키워드: $data");

        // ✅ 다이얼로그 띄우기 (현재 화면에서 요약 확인)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("최종 선택 확인"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("🎨 테마: ${data['theme']}"),
                  Text("🎭 분위기: ${data['mood']}"),
                  Text("🌈 색상: ${data['color']}"),
                  Text(
                    "📝 추가 요청: ${ (data['request'] ?? '').length > 10
                        ? data['request']!.substring(0, 10) + '...'
                        : data['request'] ?? '' }",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // ✅ 다이얼로그 닫기 (홈 이동 안 함)
                  },
                  child: Text("수정하기"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()), // ✅ 홈 화면 이동
                          (route) => false, // ✅ 이전 화면 모두 제거
                    );
                  },
                  child: Text("확인하고 홈으로"),
                ),
              ],
            );
          },
        );
      } else {
        print("추가 요청 사항을 입력해주세요!");
      }
    }


  }

  void selectKeyword(String keyword) {
    setState(() {
      if(stepIndex == 0) data['theme'] = keyword;
      if(stepIndex == 1) data['mood'] = keyword;
      if(stepIndex == 2) data['color'] = keyword;
    });
    print("현재 선택된 키워드 상태: $data"); // ✅ 현재 상태 출력

  }

  void _prevStep() {
    if (stepIndex > 0) {
      setState(() {
        stepIndex--;
      });
    } else if (stepIndex == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("알림"),
            content: Text(
              "홈화면으로 돌아가시겠습니까?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("취소"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false,
                  );
                },
                child: Text("확인"),
              ),
            ],
          );
        },
      );
    }
  }
  Widget buildStepWidget(int stepIndex) {
    if (stepIndex == 3) { // ✅ 4단계 (텍스트 입력)
      return TextFormField(
        controller: promptController,
        decoration: InputDecoration(
          labelText: '추가 요청 사항을 입력해주세요!',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
          color: Colors.white, // 입력된 텍스트 색상 변경 (예: 흰색)
          fontSize: 12, // 폰트 크기 조정 (선택 사항)
          fontWeight: FontWeight.w500, // 폰트 굵기 (선택 사항)
          ),
          minLines: 2,
          maxLines: 9,
          onChanged: (value) {
          setState(() {
            data['request'] = value;
          });
        },
      );
    } else { // ✅ 0~2단계 (키워드 선택)
      List<String> keywords = [];

      if (stepIndex == 0) {
        keywords = ["바다", "전통", "학교", "만화", "놀이공원", "동산"];
      } else if (stepIndex == 1) {
        keywords = ["귀여운", "멋진", "활기찬", "세련된", "웅장한", "신선한"];
      } else if (stepIndex == 2) {
        keywords = ["빨강", "노랑", "초록", "파랑", "민트", "핑크", "강병민", "흰색"];
      }

      return GridView.builder(
        shrinkWrap: true, // ✅ 부모 위젯 크기에 맞추기
        physics: NeverScrollableScrollPhysics(), // ✅ 스크롤 방지 (부모가 스크롤링 할 경우)
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // ✅ 한 줄에 3개씩 배치
          crossAxisSpacing: 8.0, // ✅ 버튼 사이의 가로 간격
          mainAxisSpacing: 8.0, // ✅ 버튼 사이의 세로 간격
          childAspectRatio: 2.5, // ✅ 버튼 비율 조정 (너비 대비 높이)
        ),
        itemCount: keywords.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 100, // ✅ 버튼 너비 고정
            height: 40, // ✅ 버튼 높이 고정
            child: TagToggleButton(
              buttonText: keywords[index],
              isSelected: (stepIndex == 0 && data['theme'] == keywords[index]) ||
                  (stepIndex == 1 && data['mood'] == keywords[index]) ||
                  (stepIndex == 2 && data['color'] == keywords[index]),
              onTap: () {
                selectKeyword(keywords[index]);
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0),
      backgroundColor: Colors.black.withOpacity(0.7),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${stepIndex + 1}/4",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    stepPromptDescription[stepIndex],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 30),
                ],
              ),

              SizedBox(
                width: double.infinity,
                child: buildStepWidget(stepIndex), // ✅ 동적으로 UI 생성
              ),

              const SizedBox(height: 60),

              SizedBox(
                width: double.infinity,
                child: Divider(color: Color.fromRGBO(229, 231, 235, 1), thickness: 1.5),
              ),
              const SizedBox(height: 5),

              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: DialogStepButton(
                      direction: stepIndex == 0 ? '취소' : '이전',
                      onPressed: _prevStep,
                    ),
                  ),
                  Expanded(
                    child: DialogStepButton(
                      direction: stepIndex < 3 ? '다음' : '완료',
                      onPressed: _nextStep,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ DialogStepButton 추가
class DialogStepButton extends StatelessWidget {
  final String direction;
  final VoidCallback onPressed;

  const DialogStepButton({
    required this.direction,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: (direction == '다음' || direction == '완료')
            ? Color(0xff364F6B)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(
          color: (direction == '다음' || direction == '완료')
              ? Color(0xff364F6B)
              : Color.fromRGBO(229, 231, 235, 1),
        ),
      ),
      child: Text(
        direction,
        style: TextStyle(
          color: (direction == '다음' || direction == '완료')
              ? Colors.white
              : Color.fromRGBO(22, 188, 136, 1),
        ),
      ),
    );
  }
}
