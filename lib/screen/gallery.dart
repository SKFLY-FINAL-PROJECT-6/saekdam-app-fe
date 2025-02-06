import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ImagePicker _picker = ImagePicker();
  List<String> _images = [];  // List<String>으로 변경, 경로를 저장

  @override
  void initState() {
    super.initState();
    addImage("asset/img/paint1.jpg");
    addImage("asset/img/paint2.jpg");  // asset 이미지를 경로로 추가
    addImage("asset/img/paint3.jpg");  // asset 이미지를 경로로 추가
    addImage("asset/img/paint4.jpg");  // asset 이미지를 경로로 추가
// asset 이미지를 경로로 추가
  }

  void addImage(String imagePath) {
    setState(() {
      _images.add(imagePath);  // String으로 경로만 저장
    });
  }

  Future<void> _pickImage() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => file.path));
      });
    }
  }
  //fasdfasffa

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          elevation: 0,
          title: null,
          centerTitle: false,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 15),
                child: Row(
                  children: [
                    Image.asset(
                      'asset/img/logo_rm.png',
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      ':Gallery',
                      style: TextStyle(
                        fontFamily: 'sunflower',
                        fontSize: 16,
                        color: Colors.grey,
                      ),

                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImagePreviewScreen(image: _images[index]),
                ),
              );
            },
            child: _images[index].startsWith('asset')
                ? Image.asset(_images[index], fit: BoxFit.cover) // asset 이미지
                : Image.file(File(_images[index]), fit: BoxFit.cover), // 파일 이미지
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String image; // String으로 경로를 받음
  const ImagePreviewScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: image.startsWith('asset')
            ? Image.asset(image) // asset 이미지
            : Image.file(File(image)), // 파일 이미지
      ),
    );
  }
}
