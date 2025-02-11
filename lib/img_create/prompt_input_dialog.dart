import 'package:flutter/material.dart';
import 'package:fly_ai_1/img_create/loading_screen.dart';

class PromptInputDialog extends StatefulWidget {
  const PromptInputDialog({super.key});

  @override
  State<PromptInputDialog> createState() => _PromptInputDialogState();
}

class _PromptInputDialogState extends State<PromptInputDialog> {
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

              // 유저 행동 유도도
              SizedBox(
                width: double.infinity,
                child: Text(
                  '원하는 태그를 선택해주세요.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 입력 프롬프트 설명
              SizedBox(
                width: double.infinity,
                child: Text(
                  '메인 테마',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 태그 목록
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    TagButton("Nature"),
                    TagButton("Abstract"),
                    TagButton("Fantasy"),
                    TagButton("Loren"),
                    TagButton("Ipsum"),
                    TagButton("Loren"),
                    TagButton("Ipsum"),
                  ],
                ),
              ),

              // 공백
              const SizedBox(height: 60),

              // 실선
              SizedBox(
                  width: double.infinity,
                  child: Divider(
                      color: Color.fromRGBO(229, 231, 235, 1), thickness: 1.5)),

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
                      direction: '취소',
                      onPressed: () {},
                    ),
                  ),
                  // SizedBox(width: 12),
                  Expanded(
                    child: DialogStepButton(
                      direction: '다음',
                      onPressed: () {
                        print('fdsafadsfadsfadsf');
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

// 태그 선택 버튼
class TagButton extends StatefulWidget {
  // buttonText는 한 번 정해지면 바뀔 일이 없으니 final로 지정
  final String buttonText;

  const TagButton(this.buttonText, {super.key});

  @override
  State<TagButton> createState() => _TagButtonState();
}

class _TagButtonState extends State<TagButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Color.fromRGBO(22, 188, 136, 1) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      ),
      child: Text(
        widget.buttonText,
        style: TextStyle(
          color: isSelected ? Colors.white : Color.fromRGBO(22, 188, 136, 1),
        ),
      ),
    );
  }
}

// Dialog의 스텝 버튼
// '다음' 혹은 '완료'이면 초록 배경에 흰 글씨, 그 외(취소 혹은 뒤로)면 흰 배경에 초록 글씨/외곽선선
class DialogStepButton extends StatefulWidget {
  // 버튼 안에 들어갈 글자 ('다음', '완료', '이전', '취소')
  final String direction;
  // 버튼을 눌렀을 때의 작업을 콜백 함수로 받아옴
  final VoidCallback onPressed;

  const DialogStepButton(
      {required this.direction, required this.onPressed, super.key});

  @override
  State<DialogStepButton> createState() => _DialogStepButtonState();
}

class _DialogStepButtonState extends State<DialogStepButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: (widget.direction == '다음' || widget.direction == '완료')
            ? Color.fromRGBO(22, 188, 136, 1)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(
          color: (widget.direction == '다음' || widget.direction == '완료')
              ? Color.fromRGBO(22, 188, 136, 1)
              : Color.fromRGBO(229, 231, 235, 1),
        ),
      ),
      child: Text(
        widget.direction,
        style: TextStyle(
            color: (widget.direction == '다음' || widget.direction == '완료')
                ? Colors.white
                : Color.fromRGBO(22, 188, 136, 1)),
      ),
    );
  }
}
