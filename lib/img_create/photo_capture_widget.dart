import 'package:flutter/material.dart';
import 'package:fly_ai_1/img_create/prompt_input_screen.dart';
import 'package:image_picker/image_picker.dart';

class PhotoCaptureWidget extends StatefulWidget {
  const PhotoCaptureWidget({super.key});

  @override
  State<PhotoCaptureWidget> createState() => _PhotoCaptureWidgetState();
}

class _PhotoCaptureWidgetState extends State<PhotoCaptureWidget> {
  // ImagePicker 초기화
  final ImagePicker picker = ImagePicker();

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    /*
    pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    imageSource가 ImageSource.camera라면 카메라로 찍은 사진을,
    imageSource가 ImageSource.gallery라면 갤러리에서 선택한 사진을 가져온다
    */
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    // 가져온 이미지가 null이 아니라면 진입
    if (pickedFile != null) {
      Navigator.of(context).push(
        // PageRouteBuilder : 전환 애니메이션을 직접 제어하기 위한 클래스
        // MaterialPageRoute는 애니메이션을 완전히 제거할 수 없다고 함
        PageRouteBuilder(
          // 다음 페이지 지정정
          pageBuilder: (context, animation, secondaryAnimation) =>
              PromptInputScreen(image: pickedFile),
          // 애니메이션 지속 시간 0으로 설정
          transitionDuration: Duration.zero,
          // 뒤로가기 애니메이션도 제거
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // 애니메이션 없이 바로 표시
            return child;
          },
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getImage(ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
