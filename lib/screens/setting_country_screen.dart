import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sense_voka/core/global_variables.dart';

import '../enums/app_enums.dart';

class SettingCountryScreen extends StatefulWidget {
  const SettingCountryScreen({super.key});

  @override
  State<SettingCountryScreen> createState() => _SettingCountryScreenState();
}

class _SettingCountryScreenState extends State<SettingCountryScreen> {
  static final storage = FlutterSecureStorage();

  //언어 설정
  String? _selectedCountry = voiceCountry.name;

  //언어 종류
  final List<Map<String, dynamic>> _countryCategories = [
    {"text": "미국", "Country": "us"},
    {"text": "영국", "Country": "uk"},
    {"text": "호주", "Country": "aus"},
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initValue();
  }

  //변수 초기화
  void initValue() async {
    try {
      String? storedCountry = await storage.read(key: "Country");
      if (kDebugMode) {
        print("저장소 설정 국가 : $storedCountry");
        print("설정 국가 목록 : $_countryCategories");
      }
      setState(() {
        _selectedCountry = storedCountry ?? _countryCategories.first["Country"];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        _selectedCountry = _countryCategories.first["Country"];
        isLoading = false;
      });
      if (kDebugMode) {
        print('발음 국가 저장 정보 가져오기 에러: $e');
      }
    }
  }

  // 국가 설정 저장
  void _saveCountrySetting(String country) async {
    try {
      if (kDebugMode) {
        print("설정 변경 국가 : $country");
      }
      voiceCountry = Country.values.byName(country);
      await storage.write(key: "Country", value: country);
    } catch (e) {
      if (kDebugMode) {
        print('발음 국가 설정 저장 에러: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 40,
            color: Color(0xFFFF983D),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        title: SizedBox(
          width: double.infinity,
          child: const Text(
            "음성 관리",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFF983D),
            ),
          ),
        ),
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFFFF983D)),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Text(
                          "음성 관리",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.white,
                      highlightColor: Colors.white,
                      onTap: () async {
                        // 필요시 추가 로직
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("원어민 발음 국가", style: TextStyle(fontSize: 18)),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  menuMaxHeight:
                                      MediaQuery.of(context).size.height * 0.3,
                                  underline: SizedBox.shrink(),
                                  value: _selectedCountry,
                                  items:
                                      _countryCategories
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e["Country"],
                                              child: Text(e["text"]),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedCountry = value.toString();
                                      });
                                      _saveCountrySetting(value.toString());
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
