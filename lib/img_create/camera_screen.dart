import 'package:camera/camera.dart';
import 'package:fly_ai_1/img_create/confirm_photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:fly_ai_1/cameras.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // 카메라 컨트롤러 인스턴스 생성
  late CameraController _controller;
  List<XFile> imageFiles = [];

  @override
  void initState() {
    super.initState();
    // 카메라 컨트롤러 초기화
    // cameras[0] : 사용 가능한 카메라
    _controller =
        CameraController(cameras[0], ResolutionPreset.max, enableAudio: false);

    _controller.initialize().then((_) {
      // 카메라가 작동되지 않을 경우 리턴
      if (!mounted) {
        return;
      }
      // 카메라의 플래시가 항상 켜지지 않도록 고정
      _controller.setFlashMode(FlashMode.off);

      // 카메라가 작동될 경우
      setState(() {});
    })
        // 카메라 오류 시
        .catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("CameraController Error : CameraAccessDenied");
            // Handle access errors here.
            break;
          default:
            print("CameraController Error");
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    // 카메라 컨트롤러 해제
    // dispose에서 카메라 컨트롤러를 해제하지 않으면 에러 가능성 존재
    _controller.dispose();
    super.dispose();
  }

  // 사진을 찍는 함수
  Future<void> _takePhoto() async {
    // 카메라가 로딩되지 않을 시 에러 메세지 보여주기
    if (!_controller.value.isInitialized) {
      return;
    }

    try {
      // 사진 촬영
      final XFile picture = await _controller.takePicture();

      // 촬영한 사진 캐싱
      setState(() {
        imageFiles.add(picture);
      });

      // 촬영한 사진 저장
      /*
      // import 'dart:io';
      // 사진을 저장할 경로 : 기본경로(storage/emulated/0/)
      Directory directory = Directory('storage/emulated/0/DCIM/MyImages');

      // 지정한 경로에 디렉터리를 생성하는 코드
      // .create : 디렉토리 생성, recursive : true - 존재하지 않는 디렉토리일 경우 자동 생성
      await Directory(directory.path).create(recursive: true);

      await File(picture.path).copy('${directory.path}/${picture.name}');
      */
    } catch (e) {
      // 에러시 메세지 출력
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 카메라가 로딩되지 않을 시 에러 메세지 보여주기
    if (!_controller.value.isInitialized) {
      return Scaffold(
        body: Center(
          child: Text('카메라 에러!!'),
        ),
      );
    }

    return Scaffold(
      // 앱 바(상단)
      appBar: AppBar(
        title: Text('CAMERA'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),

      body: Stack(
        children: [
          // 화면 전체를 차지하도록 Positioned.fill 위젯 사용
          Positioned.fill(
            // 카메라 화면이 보일 CameraPriview(controller),
            child: CameraPreview(_controller),
          ),
          // 하단 중앙에 위치시키기 위해 Align 위젯 사용
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              // 버튼 클릭 이벤트 정의를 위한 GestureDetector
              child: GestureDetector(
                onTap: () async {
                  // 사진 찍기 함수 호출
                  // 사진을 찍은 후 바로 confirm_photo_screen으로 넘어감
                  await _takePhoto();

                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConfirmPhotoScreen(
                        imageFiles: imageFiles,
                      ),
                    ),
                  );

                  // print('============================= \n $result');

                  // result가 빈 리스트([])여도, 이미지가 들어있는 리스트여도 if문 진입
                  if (result != null) {
                    // print('============================= \n 이프문 진입!');
                    setState(() {
                      // pop 됐을 시 넘어온 result로 자동 변환
                      // 1. 사진 다시 찍기를 선택했을 시 빈 리스트
                      // 2. 사진 추가 찍기를 선택했을 시 이미지가 들어있는 리스트
                      imageFiles = List<XFile>.from(result);
                    });
                  }
                  // print('============================= \n $imageFiles');
                },
                // 버튼으로 표시될 아이콘
                child: const Icon(
                  Icons.camera_enhance,
                  size: 70,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),

      // 바텀 네비게이션 바
      // bottomNavigationBar: BottomNavigationBar(items: const [
      //   BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
      // ]),
    );
  }
}
