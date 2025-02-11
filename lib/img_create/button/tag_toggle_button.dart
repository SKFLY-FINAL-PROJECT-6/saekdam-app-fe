import 'package:flutter/material.dart';

// 태그 선택 버튼
class TagToggleButton extends StatefulWidget {
  // buttonText는 한 번 정해지면 바뀔 일이 없으니 final로 지정
  final String buttonText;

  const TagToggleButton(this.buttonText, {super.key});

  @override
  State<TagToggleButton> createState() => _TagToggleButtonState();
}

class _TagToggleButtonState extends State<TagToggleButton> {
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
