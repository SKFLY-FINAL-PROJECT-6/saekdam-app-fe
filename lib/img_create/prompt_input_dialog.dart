import 'package:flutter/material.dart';
import 'package:fly_ai_1/api.dart';
import 'package:fly_ai_1/img_create/button/tag_toggle_button_widget.dart';
import 'package:fly_ai_1/screen/home_screen.dart';
import 'package:camera/camera.dart'; // ✅ 여기에 추가!
import 'dart:io';
import 'package:fly_ai_1/splash_screen.dart';
import 'package:fly_ai_1/socket.dart';
class PromptInputDialog extends StatefulWidget {
  final XFile? imageFile; // ✅ 전달받은 이미지 파일
  final Map<String, dynamic> maskData;
  const PromptInputDialog(
      {Key? key, required this.imageFile, required this.maskData})
      : super(key: key);

  @override
  State<PromptInputDialog> createState() => _PromptInputDialogState();
}

class _PromptInputDialogState extends State<PromptInputDialog> {
  int stepIndex = 0;
  TextEditingController promptController = TextEditingController();
  File? savedImage; // ✅ 저장할 이미지 변수
  final WebSocketChannelService _wsService = WebSocketChannelService();

  // data 맵은 widget.maskData에 의존하므로 initState에서 초기화합니다.
  late Map<String, String?> data;

  static const List<String> stepPromptDescription = [
    '원하는 메인 테마를 선택해주세요.',
    '추가 요청 사항을 작성해주세요.',
  ];

  static const List<String> stepPromptTitles = [
    '메인 테마',
    '',
  ];

  // 입력받게 될 프롬프트 총 개수
  final totalPromptSteps = stepPromptTitles.length;

  @override
  void initState() {
    super.initState();
    data = {
      "id": null,      // taskid (img uuid)
      "theme": null,   // 1단계: 메인 테마
      "requirement": null, // 2단계: 추가 요청 사항 (글 프롬프트)
      "x": widget.maskData["x"]?.toString(),
      "y": widget.maskData["y"]?.toString(),
      "w": widget.maskData["width"]?.toString(),
      "h": widget.maskData["height"]?.toString(),
    };
    savedImage = File(widget.imageFile!.path);

  }

  void _nextStep() {
    if (stepIndex < totalPromptSteps - 1) {
      // ✅ 0단계 (키워드 선택)
      if (stepIndex == 0 && data['theme'] != null) {
        setState(() {
          stepIndex++;
        });
      } else {
        print("키워드를 선택해주세요!");
      }
    } else if (stepIndex == totalPromptSteps - 1) {
      // ✅ 1단계 (프롬프트 입력)
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
                  Text(
                    "📝 추가 요청: ${(data['request'] ?? '').length > 10 ? data['request']!.substring(0, 10) + '...' : data['request'] ?? ''}",
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
                  onPressed: () async {
                    data['id'] = await ApiService.fetchTaskId();
                    final response = await ApiService.postTask(data);

                    print("최종 선택된 키워드: $data");
                    print(response.body);
                    String imgurl = await ApiService.getimgurl(data['id']!);
                    await ApiService.uploadImageToPresignedUrl(imgurl,savedImage!);
                    _wsService.connect(data['id']!);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SplashScreen()), // ✅ 홈 화면 이동
                          (route) => false, // ✅ 이전 화면 모두 제거
                    );
                  },
                  child: Text("디자인 생성하기"),
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
      if (stepIndex == 0) data['theme'] = keyword;
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
    if (stepIndex == totalPromptSteps - 1) {
      // ✅ 2단계 (텍스트 입력)
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
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        minLines: 2,
        maxLines: 9,
        onChanged: (value) {
          setState(() {
            data['request'] = value;
          });
        },
      );
    } else {
      // ✅ 0~2단계 (키워드 선택)
      List<String> keywords = [];
      if (stepIndex == 0) {
        keywords = ["Nature", "Urban", "Play", "Ocean", "Animals", "Space"];
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 2.5,
        ),
        itemCount: keywords.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 100,
            height: 40,
            child: TagToggleButton(
              buttonText: keywords[index],
              isSelected: (stepIndex == 0 && data['theme'] == keywords[index]),
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
                    "${stepIndex + 1}/$totalPromptSteps",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    stepPromptDescription[stepIndex],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 30),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: buildStepWidget(stepIndex),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: Divider(
                    color: Color.fromRGBO(229, 231, 235, 1), thickness: 1.5),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DialogStepButton(
                      direction: stepIndex == 0 ? '취소' : '이전',
                      onPressed: _prevStep,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: DialogStepButton(
                      direction: stepIndex < 1 ? '다음' : '완료',
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
              : Colors.black,
        ),
      ),
    );
  }
}
