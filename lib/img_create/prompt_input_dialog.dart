import 'package:flutter/material.dart';
import 'package:fly_ai_1/img_create/button/tag_toggle_button_widget.dart';

class PromptInputDialog extends StatefulWidget {
  const PromptInputDialog({super.key});

  @override
  State<PromptInputDialog> createState() => _PromptInputDialogState();
}

class _PromptInputDialogState extends State<PromptInputDialog> {
  int stepIndex = 0;

  // 각 페이지 별 프롬포트 입력에 대한 안내를 해주는 문구
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

  // TODO
  // [ ]: 모달 페이지 별 태그 선택(isSelected) 상태를 다르게 구현해야함.
  // 다음 버튼 클릭 시 처리
  void _nextStep() {
    if (stepIndex < stepPromptTitles.length - 1) {
      setState(() {
        stepIndex++;
      });
    } else {
      // 마지막 단계라면 다이얼 로그 닫기
      Navigator.pop(context);
    }
  }

  // 이전 버튼 클릭 시 처리
  void _prevStep() {
    if (stepIndex > 0) {
      setState(() {
        stepIndex--;
      });
    }
  }

  // 각 모달 별 유저에게 입력받을 프롬프트의 내용을 위젯 형태로 작성
  final Map<int, Widget> stepWidgets = {
    0: Wrap(
      spacing: 8.0,
      children: [
        TagToggleButton("바다"),
        TagToggleButton("전통"),
        TagToggleButton("학교"),
        TagToggleButton("만화"),
        TagToggleButton("놀이공원"),
        TagToggleButton("동산"),
      ],
    ),
    1: Wrap(
      spacing: 8.0,
      children: [
        TagToggleButton("귀여운"),
        TagToggleButton("멋진"),
        TagToggleButton("활기찬"),
        TagToggleButton("세련된"),
        TagToggleButton("웅장한"),
        TagToggleButton("신선한"),
      ],
    ),
    2: Wrap(
      spacing: 8.0,
      children: [
        TagToggleButton("빨강"),
        TagToggleButton("노랑"),
        TagToggleButton("초록"),
        TagToggleButton("파랑"),
        TagToggleButton("민트"),
        TagToggleButton("핑크"),
        TagToggleButton("강병민"),
        TagToggleButton("흰색"),
      ],
    ),
    3: TextFormField(
      // TextField, TextFormField의 InputDecoration 속성 정리리
      // https://velog.io/@mm723/%ED%97%B7%EA%B0%88%EB%A6%AC%EB%8A%94-textfield-decoration-%EC%A0%95%EB%A6%AC
      decoration: InputDecoration(
        labelText: 'Prompt',
        labelStyle: TextStyle(
          color: const Color.fromARGB(255, 31, 31, 31),
        ),
        fillColor: Colors.white,
        // 포커스 됐을 때 색 변경
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(22, 188, 136, 1),
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
  };

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0),
      backgroundColor: Colors.white,
      // 위젯의 최대 크기를 제한하는 위젯
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
              // 타이틀
              SizedBox(
                width: double.infinity,
                child: Text(
                  '프롬포트 입력',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 스텝 설명
              SizedBox(
                width: double.infinity,
                child: Text(
                  stepPromptDescription[stepIndex],
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 입력 프롬프트 설명
              SizedBox(
                width: double.infinity,
                height: 30,
                child: Text(
                  stepPromptTitles[stepIndex],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 태그 목록
              SizedBox(
                width: double.infinity,
                child: stepWidgets[stepIndex],
              ),

              // 공백
              const SizedBox(height: 60),

              // 실선
              SizedBox(
                width: double.infinity,
                child: Divider(
                    color: Color.fromRGBO(229, 231, 235, 1), thickness: 1.5),
              ),

              // 공백
              const SizedBox(height: 5),

              // 취소, 확인 버튼
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  Expanded(
                    child: DialogStepButton(
                      direction: stepIndex == 0 ? '취소' : '이전',
                      onPressed: () {
                        _prevStep();
                      },
                    ),
                  ),
                  // SizedBox(width: 12),
                  Expanded(
                    child: DialogStepButton(
                      direction:
                          stepIndex < stepPromptTitles.length - 1 ? '다음' : '완료',
                      onPressed: () {
                        _nextStep();
                      },
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

// Dialog의 스텝 버튼
class DialogStepButton extends StatelessWidget {
  // 버튼 안에 들어갈 글자 ('다음', '완료', '이전', '취소')
  final String direction;
  // 버튼을 눌렀을 때의 작업을 콜백 함수로 받아옴
  final VoidCallback onPressed;

  const DialogStepButton(
      {required this.direction, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: (direction == '다음' || direction == '완료')
            ? Color.fromRGBO(22, 188, 136, 1)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(
          color: (direction == '다음' || direction == '완료')
              ? Color.fromRGBO(22, 188, 136, 1)
              : Color.fromRGBO(229, 231, 235, 1),
        ),
      ),
      child: Text(
        direction,
        style: TextStyle(
            color: (direction == '다음' || direction == '완료')
                ? Colors.white
                : Color.fromRGBO(22, 188, 136, 1)),
      ),
    );
  }
}
