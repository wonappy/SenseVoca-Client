import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sense_voka/models/user_model.dart';
import 'package:sense_voka/models/user_status_model.dart';
import 'package:sense_voka/screens/essential_wordbook_screen.dart';
import 'package:sense_voka/screens/main_wordbook_screen.dart';
import 'package:sense_voka/screens/setting_account_screen.dart';
import 'package:sense_voka/screens/setting_country_screen.dart';
import 'package:sense_voka/screens/setting_goal_screen.dart';

import '../enums/app_enums.dart';
import '../services/users_service.dart';
import '../widgets/navigation_button_widget.dart';
import 'mywordbook_screen.dart';

class MainScreen extends StatefulWidget {
  final UserModel user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static final storage = FlutterSecureStorage();
  late String studyGoal;

  late Future<UserStatusModel> _userStatusFuture;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudyGoal();
    _userStatusFuture = _getUserStatus();
  }

  //학습 목표 가져오기
  Future<void> _loadStudyGoal() async {
    String? value = await storage.read(key: "StudyGoal");
    setState(() {
      studyGoal = value ?? "100";
      isLoading = false;
    });
  }

  Future<UserStatusModel> _getUserStatus() async {
    var result = await UsersService.getUserStatus();
    if (result.isSuccess && result.data != null) {
      try {
        if (result.data is UserStatusModel) {
          return result.data as UserStatusModel;
        } else if (result.data is Map<String, dynamic>) {
          return UserStatusModel.fromJson(result.data as Map<String, dynamic>);
        }
      } catch (e) {
        if (kDebugMode) {
          print('UserStatusModel 변환 실패: $e');
        }
      }
    }

    return UserStatusModel(todayCount: 0, streakDays: 0);
  }

  void _refreshUserStatus() {
    setState(() {
      _userStatusFuture = _getUserStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu_rounded, size: 40),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFF983D),
        foregroundColor: Colors.white,
        //app bar 그림자 생기게 하기
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        //
        title: const Text(
          "센스보카",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
      ),
      //환경설정 메뉴
      drawer: Drawer(
        child: Material(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFFF983D), width: 2.0),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      Text("설정", style: TextStyle(fontSize: 25)),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16, bottom: 16),
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFFFE4CA),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFFF983D), width: 2.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.user.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          " 님, 환영합니다.",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                    Text(
                      widget.user.email,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
              InkWell(
                splashColor: Color(0xFFFF983D),
                highlightColor: Color(0xFFFFE4CA),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              SettingAccountScreen(id: widget.user.userId),
                    ),
                  ).then((_) {
                    _loadStudyGoal();
                  });
                },
                child: ListTile(
                  title: Text(
                    "계정 관리",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("로그아웃  |  회원 탈퇴"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              // Divider(color: Color(0xFFFF983D), thickness: 2.0, height: 8.0),
              // InkWell(
              //   splashColor: Color(0xFFFF983D),
              //   highlightColor: Color(0xFFFFE4CA),
              //   onTap: () {
              //     // 이벤트 처리
              //   },
              //   child: ListTile(
              //     title: Text(
              //       "언어",
              //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //     ),
              //     subtitle: Text("기본 언어 설정"),
              //     trailing: Icon(Icons.arrow_forward_ios),
              //   ),
              // ),
              Divider(color: Color(0xFFFF983D), thickness: 2.0, height: 8.0),
              InkWell(
                splashColor: Color(0xFFFF983D),
                highlightColor: Color(0xFFFFE4CA),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingCountryScreen(),
                    ),
                  ).then((_) {
                    _loadStudyGoal();
                  });
                },
                child: ListTile(
                  title: Text(
                    "음성",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("원어민 발음 설정"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              Divider(color: Color(0xFFFF983D), thickness: 2.0, height: 8.0),
              InkWell(
                splashColor: Color(0xFFFF983D),
                highlightColor: Color(0xFFFFE4CA),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingGoalScreen(),
                    ),
                  ).then((_) {
                    _loadStudyGoal();
                  });
                },
                child: ListTile(
                  title: Text(
                    "단어 학습",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("1일 학습 목표 설정"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              Divider(color: Color(0xFFFF983D), thickness: 2.0, height: 8.0),
            ],
          ),
        ),
      ),

      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFFFF983D)),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 사용자 프로필 및 점수
                      Container(
                        padding: EdgeInsets.all(13),
                        width: 370,
                        height: 280,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFE4CA),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              offset: Offset(0, 8),
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //CircleAvatar(radius: 40, backgroundColor: Colors.white),
                                Container(
                                  width: 120,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 120,
                                    color: Colors.black12,
                                  ),
                                ),
                                SizedBox(width: 25),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '오늘 학습한 단어',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        FutureBuilder<UserStatusModel>(
                                          future: _userStatusFuture,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }

                                            final userStatus = snapshot.data;
                                            return Text(
                                              '${userStatus?.todayCount}',
                                              style: TextStyle(
                                                fontSize: 50,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFFF983D),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          '/ $studyGoal 개',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 25),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.user.name,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '님, 연속 학습 ',
                                  style: TextStyle(fontSize: 15),
                                ),
                                FutureBuilder<UserStatusModel>(
                                  future: _userStatusFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }

                                    final userStatus = snapshot.data!;
                                    return Text(
                                      '${userStatus.streakDays}',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    );
                                  },
                                ),
                                Text('일 째입니다.', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      NavigationButtonWidget(
                        onPopped: _refreshUserStatus,
                        text: "기본 제공 단어장",
                        bHeight: 90,
                        bWidth: 360,
                        destinationScreen: EssentialWordBookScreen(),
                      ),
                      SizedBox(height: 10),
                      NavigationButtonWidget(
                        onPopped: _refreshUserStatus,
                        text: "나만의 단어장",
                        bHeight: 90,
                        bWidth: 360,
                        destinationScreen: MyWordBookScreen(),
                      ),
                      SizedBox(height: 10),
                      NavigationButtonWidget(
                        onPopped: _refreshUserStatus,
                        text: "즐겨찾기 단어장",
                        bHeight: 90,
                        bWidth: 360,
                        destinationScreen: MainWordBookScreen(
                          type: WordBook.favorite,
                          wordbookId: 0,
                          setName: "즐겨찾기 단어장",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
