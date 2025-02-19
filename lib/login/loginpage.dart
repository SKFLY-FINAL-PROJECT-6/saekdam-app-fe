import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fly_ai_1/login/start.dart';
import 'package:fly_ai_1/constant/color.dart';
import 'package:fly_ai_1/screen/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Map<String, String> _registeredUser = {
    "email": "kbm20008",
    "password": "pwd12345"
  };

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoginButtonEnabled = false;

  /// 로딩 상태 플래그 (두 번째 코드 참고)
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 폼 검증
  void _validateForm() {
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

  /// 기존 ID/PW 로그인 예시
  Future<void> _onLoginPressed() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email == _registeredUser["email"] && password == _registeredUser["password"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 성공!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일 또는 비밀번호가 일치하지 않습니다.')),
      );
    }
  }

  /// 두 번째 코드에서 가져온 구글 로그인 로직
  Future<UserCredential> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // 사용자가 로그인 창에서 취소한 경우 예외를 발생시킵니다.
        setState(() {
          _isLoading = false;
        });
        throw Exception("사용자가 Google 로그인 과정을 취소했습니다.");
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        _isLoading = false;
      });

      return userCredential;
    } catch (e) {
      print('Google Sign-In Error: $e');
      setState(() {
        _isLoading = false;
      });
      // 에러 발생 시 null 대신 예외를 던집니다.
      throw Exception("Google Sign-In 중 오류 발생: $e");
    }
  }

  /// 구글 로그인 버튼 눌렀을 때 실행되는 함수
  Future<void> _login() async {
    UserCredential? userCredential = await _signInWithGoogle();
    if (userCredential != null) {
      // 구글 로그인 성공 시 HomeScreen으로 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
      );
    } else {
      // 로그인 실패 혹은 취소된 경우 스낵바 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google 로그인에 실패했습니다.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final bool fromLogout = ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: (ModalRoute.of(context)?.settings.arguments as bool? ?? false)
            ? null // 🔹 로그아웃을 통해 들어왔으면 뒤로가기 버튼 제거
            : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            text: "벽화를",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: " 색다르게",
                            style: TextStyle(color: pinkmain),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "맞춤형 디자인을 생성해 보세요!",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
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
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StartPage()),
                            );
                          },
                          child: const Text("회원가입"),
                        ),
                        Container(height: 15, child: const VerticalDivider(color: greymain)),
                        TextButton(
                          onPressed: () {
                            // 비밀번호 찾기
                          },
                          child: const Text("비밀번호 찾기"),
                        ),
                        Container(height: 15, child: const VerticalDivider(color: greymain)),
                        TextButton(
                          onPressed: () {
                            // 비회원 로그인
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          },
                          child: const Text("비회원 로그인"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //kakao
                        IconButton(
                          icon: SvgPicture.asset(
                            'asset/img/btn_kakao.svg',
                            width: 50,
                            height: 50,
                          ),
                          onPressed: _login, // 새로 정의한 함수로 교체
                        ),
                        // Google
                        IconButton(
                          icon: SvgPicture.asset(
                            'asset/img/btn_google.svg',
                            width: 50,
                            height: 50,
                          ),
                          onPressed: _login, // 새로 정의한 함수로 교체
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 로딩 인디케이터 (원하시면 추가)
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

