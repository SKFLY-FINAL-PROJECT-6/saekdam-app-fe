import 'package:flutter/material.dart';
import 'package:fly_ai_1/constant/color.dart';
import 'package:fly_ai_1/login/loginpage.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();

  String _emailError = '';
  String _passwordError = '';
  String _confirmError = '';

  bool _isSignUpEnabled = false; // 가입완료 버튼 활성화 상태

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // 이메일 검증
  void _validateEmail(String value) {
    if (value.length < 8) {
      setState(() {
        _emailError = '이메일은 8자 이상이어야 합니다.';
      });
    } else {
      setState(() {
        _emailError = '';
      });
    }
    _checkFormValidity();
  }

  // 비밀번호 검증
  void _validatePassword(String value) {
    if (value.length < 8) {
      setState(() {
        _passwordError = '비밀번호는 8자 이상이어야 합니다.';
      });
    } else {
      setState(() {
        _passwordError = '';
      });
    }
    _checkFormValidity();
  }

  // 비밀번호 확인 검증
  void _validateConfirm(String value) {
    if (value != _passController.text) {
      setState(() {
        _confirmError = '비밀번호가 일치하지 않습니다.';
      });
    } else {
      setState(() {
        _confirmError = '';
      });
    }
    _checkFormValidity();
  }

  // 폼 유효성 확인
  void _checkFormValidity() {
    final isFormValid = _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _emailError.isEmpty &&
        _passController.text.isNotEmpty &&
        _passwordError.isEmpty &&
        _confirmController.text.isNotEmpty &&
        _confirmError.isEmpty;

    setState(() {
      _isSignUpEnabled = isFormValid; // 모든 조건을 만족하면 활성화
    });
  }

  // 가입 완료 버튼 클릭 시
  void _onSignUp() {
    if (_isSignUpEnabled) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(), // 로그인 페이지로 이동
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 11),

              // 부제목
              Row(
                children: [
                  const Text(
                    '벽화를 ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '색다르게',
                    style: TextStyle(
                      fontSize: 16,
                      color: pinkmain,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // (1) 이름 입력
              TextField(
                controller: _nameController,
                onChanged: (value) => _checkFormValidity(),
                decoration: const InputDecoration(
                  labelText: '이름',
                  hintText: "이름을 입력하세요",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // (2) 이메일 입력
              TextField(
                controller: _emailController,
                onChanged: _validateEmail,
                decoration: InputDecoration(
                  labelText: '이메일',
                  hintText: "이메일을 입력하세요",
                  border: OutlineInputBorder(),
                  errorText: _emailError.isNotEmpty ? _emailError : null,
                ),
              ),
              const SizedBox(height: 20),

              // (3) 비밀번호 입력
              TextField(
                controller: _passController,
                onChanged: _validatePassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  hintText: "비밀번호를 입력하세요",
                  border: OutlineInputBorder(),
                  errorText: _passwordError.isNotEmpty ? _passwordError : null,
                ),
              ),
              const SizedBox(height: 20),

              // (4) 비밀번호 확인
              TextField(
                controller: _confirmController,
                onChanged: _validateConfirm,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  hintText: "비밀번호를 입력하세요",
                  border: OutlineInputBorder(),
                  errorText: _confirmError.isNotEmpty ? _confirmError : null,
                ),
              ),
              const Spacer(),

              // (5) 가입완료 버튼
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pinkmain,
                    disabledBackgroundColor: Color(0xFFffcce4), // 조건에 따라 색상 변경
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isSignUpEnabled ? _onSignUp : null, // 조건에 따라 활성화/비활성화
                  child: const Text(
                    '가입완료',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
