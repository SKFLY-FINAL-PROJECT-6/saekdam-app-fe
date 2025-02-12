import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fly_ai_1/constant/color.dart';
import 'package:fly_ai_1/login/loginpage.dart';
import 'package:fly_ai_1/setting/profile_edit.dart';

class ProfileSetting extends StatefulWidget {
  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  String nickname = "색담이"; // 기본 닉네임
  File? profileImage; // 사용자가 선택한 프로필 이미지

  /// 🔹 프로필 수정 화면으로 이동 & 결과 받아오기
  Future<void> _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(
          initialName: nickname,
          initialProfileImage: profileImage,
        ),
      ),
    );

    // 사용자가 수정한 닉네임과 프로필 사진을 적용
    if (result != null) {
      setState(() {
        nickname = result['name'] ?? nickname;
        profileImage = result['profileImage'] ?? profileImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "내 프로필",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기
          },
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                /// 🔹 프로필 이미지 (기본 이미지 or 사용자가 변경한 이미지)
                CircleAvatar(
                  radius: 60,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : AssetImage('asset/img/색담이_rm.png') as ImageProvider,
                ),
                SizedBox(height: 10),

                /// 🔹 닉네임 표시
                Text(nickname, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                /// 🔹 프로필 수정 버튼
                TextButton(
                  onPressed: _editProfile, // 프로필 수정 화면으로 이동
                  child: Text("프로필 수정", style: TextStyle(color: pinkmain)),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Divider()),

          /// 🔹 계정 설정 섹션
          _buildSectionTitle("계정"),
          _buildListTile("이메일 변경", EmailChangeScreen()),
          _buildListTile("비밀번호 변경", PasswordChangeScreen()),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Divider()),

          /// 🔹 이용 안내 섹션
          _buildSectionTitle("이용 안내"),
          _buildListTile("앱 버전", null, trailing: Text("1.0.1")),
          _buildListTile("문의하기", InquiryScreen()),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Divider()),

          /// 🔹 기타 설정 섹션
          _buildSectionTitle("기타"),
          _buildListTile("회원 탈퇴", WithdrawalScreen()),

          /// 🔹 로그아웃 기능
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListTile(
              title: Text("로그아웃"),
              onTap: () {
                // 🔹 모든 이전 화면 제거 후 로그인 페이지로 이동
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                    settings: RouteSettings(arguments: true),
                  ),
                      (Route<dynamic> route) => false, // 이전 화면 삭제
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 섹션 제목 위젯
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }

  /// 🔹 리스트 아이템 위젯 (설정 항목)
  Widget _buildListTile(String title, Widget? targetScreen, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        title: Text(title),
        trailing: trailing,
        onTap: targetScreen != null
            ? () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
        }
            : null,
      ),
    );
  }
}

/// 🔹 이메일 변경 페이지
class EmailChangeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("이메일 변경")));
  }
}

/// 🔹 비밀번호 변경 페이지
class PasswordChangeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("비밀번호 변경")));
  }
}

/// 🔹 문의하기 페이지
class InquiryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("문의하기")));
  }
}

/// 🔹 회원 탈퇴 페이지
class WithdrawalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("회원 탈퇴")));
  }
}
