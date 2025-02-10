import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

final homeUrl = Uri.parse("https://blog.codefactory.ai");
class Community extends StatelessWidget {
  WebViewController controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..loadRequest(homeUrl);

  //.. 은 함수를 실행한 대상을 반환 .은 함수를 실행한 값을 반환
  Community({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.limeAccent,
        title: Text('벽화를 색다르게'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                controller.loadRequest(homeUrl);
              },
              icon: Icon(
                Icons.home,
              )),
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
