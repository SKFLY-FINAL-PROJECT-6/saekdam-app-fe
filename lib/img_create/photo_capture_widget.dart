import 'package:flutter/material.dart';
import 'package:fly_ai_1/img_create/prompt_input_screen.dart';
import 'package:fly_ai_1/screen/home_screen.dart';
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PromptInputScreen(image: pickedFile),
        ),
      );
    } else {
      // 📌 사용자가 사진을 찍지 않고 뒤로 갔을 때 → 홈 화면으로 이동
      Navigator.pop(context);
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
    return HomeScreen();
  }
}
