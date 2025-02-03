import 'package:flutter/material.dart';
import 'dart:async'; // Timer 사용을 위해 필요한 패키지

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  Timer? timer;
  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    // 3초마다 자동으로 PageView 넘기는 타이머
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final currentPage = controller.page?.toInt() ?? 0;
      var nextPage = currentPage + 1;

      // 3(4번째 페이지) → 0(첫 번째 페이지) 갈 때는 animateToPage 대신 jumpToPage
      if (nextPage > 3) {
        // 페이지 순간 이동
        controller.jumpToPage(0);
      } else {
        // 나머지는 부드러운 애니메이션
        controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 탭 개수
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            children: [
              Image.asset(
                'asset/img/logo_rm.png',
                height: 40,
              ),
              const SizedBox(width: 8),
              const Text(
                ':벽화를 색다르게',
                style: TextStyle(
                  fontFamily: 'sunflower',
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          ///연결 ,아이콘 클릭했을 때
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Community'),
            ],
            labelColor: Colors.pinkAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.pinkAccent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3.0,
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // ------------------------------------------------
            // 1) 첫 번째 탭(Home)
            // ------------------------------------------------
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1) 자동 슬라이드 배너
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 250,
                        child: PageView(
                          controller: controller,
                          children: [1, 2, 3, 4].map(
                            (e) {
                              return Image.asset(
                                'asset/img/paint$e.jpg',
                                fit: BoxFit.cover,
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),

                  // 2) Generate Image 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Generate Image',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'sunflower',
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3) Community 헤더
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const Text(
                          'Community',
                          style: TextStyle(
                            fontFamily: 'sunflower',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.pinkAccent,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 4) Community 카드 (커스텀 디자인으로 '크기' 키움)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 120, // 🔥 높이를 크게 설정
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            offset: const Offset(0, 3),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // 이미지
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            child: Image.asset(
                              'asset/img/image_1.jpg',
                              width: 120, // 🔥 이미지를 더 넓게/크게
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // 오른쪽 정보
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Skt fly ai',
                                    style: TextStyle(
                                      fontFamily: 'sunflower',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    '벽화그리기 채색봉사자 모집',
                                    style: TextStyle(
                                      fontFamily: 'sunflower',
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.thumb_up_off_alt,
                                        color: Colors.pinkAccent,
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text('33'),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        color: Color(0xFF6799FF),
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text('6'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 5) Gallery 헤더
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Gallery',
                          style: TextStyle(
                            fontFamily: 'sunflower',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.pinkAccent,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 6) Gallery 카드
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 120, // 🔥 높이 조절
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            offset: const Offset(0, 3),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // 이미지
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            child: Image.asset(
                              'asset/img/wall_1.jpg',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // 오른쪽 정보
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '벽화이미지_1',
                                    style: TextStyle(
                                      fontFamily: 'sunflower',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    '광진구 벽화 마을 이미지 1번째 도안',
                                    style: TextStyle(
                                        fontFamily: 'sunflower',
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Details 버튼
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.pinkAccent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                              ),
                              child: const Text('View Details'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ------------------------------------------------
            // 2) 두 번째 탭(Community)
            // ------------------------------------------------
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Community',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Community 예시 카드도 크게
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            offset: const Offset(0, 3),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            child: Image.asset(
                              'asset/img/image_1.jpg',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Skt fly ai',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    '벽화그리기 채색봉사자 모집',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.thumb_up,
                                        color: Colors.pinkAccent,
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text('33'),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.comment,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text('6'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ------------------------------------------------
        // 하단 네비게이션 바
        // ------------------------------------------------
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.pinkAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Generate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_in_ar),
              label: 'AR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Community',
            ),
          ],
        ),
      ),
    );
  }
}
