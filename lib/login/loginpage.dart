import 'package:flutter/material.dart';
import 'package:fly_ai_1/constant/color.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fly_ai_1/screen/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 실제 앱에서는 서버나 로컬 DB의 회원가입 정보를 받아 비교한다고 가정
  // 여기서는 예시를 간단히 보여주기 위해 임시로 작성
  final Map<String, String> _registeredUser = {
    "email": "kbm20008",
    "password": "pwd12345"
  };

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoginButtonEnabled = false;

  // 구글 간편로그인 객체
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    // TextField 변화 감지용 리스너 등록
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    // 이메일 혹은 비밀번호가 비어있으면 로그인 버튼 비활성화
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      setState(() {
        _isLoginButtonEnabled = true;
      });
    } else {
      setState(() {
        _isLoginButtonEnabled = false;
      });
    }
  }

  Future<void> _onLoginPressed() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email == _registeredUser["email"] && password == _registeredUser["password"]) {
      // 로그인 성공 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 성공!')),
      );
      // 다음 화면으로 이동 혹은 원하는 동작 수행
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // 로그인 실패 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일 또는 비밀번호가 일치하지 않습니다.')),
      );
    }
  }

  /// 구글 간편로그인 예시
  Future<void> _handleGoogleSignIn() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user == null) {
        // 로그인 취소
        return;
      }
      // 로그인 성공
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.displayName} 님, 구글 로그인 성공')),
      );
      // 서버와 토큰 교환 로직 또는 다른 후속 조치
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('구글 로그인 중 오류가 발생했습니다: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      const TextSpan(
                        text: "벽화를",
                        style: TextStyle(color: Colors.black),
                      ),
                      const TextSpan(
                        text: " 색다르게",
                        style: TextStyle(color: pinkmain),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "맞춤형 디자인을 생성해 보세요!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "이메일",
                    hintText: "이메일을 입력하세요",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "비밀번호",
                    hintText: "비밀번호를 입력하세요",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pinkmain,
                      disabledBackgroundColor: Color(0xFFffcce4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoginButtonEnabled ? _onLoginPressed : null,

                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // 회원가입 화면으로 이동
                      },
                      child: const Text("회원가입"),
                    ),
                    Container(height: 15, child: const VerticalDivider(color: greymain)),
                    TextButton(
                      onPressed: () {
                        // 비밀번호 찾기 화면 이동
                      },
                      child: const Text("비밀번호 찾기"),
                    ),
                    Container(height: 15, child: const VerticalDivider(color: greymain)),
                    TextButton(
                      onPressed: () {
                        // 비회원 로그인 로직
                      },
                      child: const Text("비회원 로그인"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                // 간편로그인 아이콘들
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Naver
                    IconButton(
                      icon: Image.asset(
                        'asset/img/btnG_아이콘원형.png',
                        width: 50,
                        height: 50,
                      ),
                      onPressed: () {
                        // 네이버 간편로그인 로직
                      },
                    ),
                    // Kakao
                    IconButton(
                      icon: SvgPicture.asset(
                        'asset/img/btn_kakao.svg',
                        width: 50,
                        height: 50,
                      ),
                      onPressed: () {
                        // 카카오 간편로그인 로직
                      },
                    ),
                    // Google
                    IconButton(
                      icon: SvgPicture.asset(
                        'asset/img/btn_google.svg',
                        width: 50,
                        height: 50,
                      ),
                      onPressed: _handleGoogleSignIn,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}