// 이 파일은 앱의 가장 중요한 부분이에요. 앱이 어떻게 시작되고, 어떤 화면들을 보여줄지 정해요.

import 'dart:convert'; // 글자를 컴퓨터가 알아들을 수 있는 형태로 바꾸는 도구예요.

import 'package:flutter/material.dart'; // Flutter 앱을 만드는 데 필요한 기본 도구들을 가져와요.
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:numerology/locale_provider.dart';
import 'package:numerology/screens/result_screen.dart'; // 계산 결과를 보여주는 화면 코드를 가져와요.
import 'package:numerology/themes.dart'; // 앱의 색깔과 글씨 모양을 정하는 코드들을 가져와요.
import 'package:numerology/widgets/custom_app_screen.dart'; // 앱의 기본 틀(아래쪽 메뉴바 같은 것)을 만드는 코드를 가져와요.
import 'package:shared_preferences/shared_preferences.dart'; // 앱을 껐다 켜도 정보를 기억하게 해주는 도구예요.
import 'package:provider/provider.dart'; // 앱의 중요한 정보(테마 같은 것)를 여러 화면에서 함께 쓸 수 있게 도와주는 도구예요.
import 'package:numerology/theme_provider.dart'; // 앱의 테마(밝은 모드, 어두운 모드)를 관리하는 특별한 도구를 가져와요.

// 앱이 처음 시작될 때 가장 먼저 실행되는 부분이에요.
void main() {
  // 앱을 화면에 보여줘요.
  runApp(
    // 여러 Provider를 함께 사용할 수 있게 해주는 MultiProvider를 사용해요.
    MultiProvider(
      providers: [
        // 'ThemeProvider'라는 도구를 앱 전체에서 사용할 수 있게 해줘요.
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        // 'LocaleProvider'라는 도구를 앱 전체에서 사용할 수 있게 해줘요.
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      // 'MyApp'이라는 앱의 가장 큰 부분을 'ThemeProvider'와 'LocaleProvider'와 함께 실행해요.
      child: const MyApp(),
    ),
  );
}

// 우리 앱의 가장 큰 부분이에요. 앱의 전체적인 모습을 정해요.
// 이 부분은 스스로 변하지 않아서 'StatelessWidget'으로 만들었어요.
class MyApp extends StatelessWidget {
  // 'MyApp' 위젯을 만들 때 필요한 기본 정보예요.
  const MyApp({super.key});

  // 이 함수는 앱이 화면에 어떻게 보일지 정하는 부분이에요.
  @override
  Widget build(BuildContext context) {
    // 'ThemeProvider'와 'LocaleProvider'의 정보를 지켜보고 있다가, 정보가 바뀌면 앱의 테마와 언어를 바꿔줘요.
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        // 앱의 기본 틀을 만들어요. (제목, 테마, 첫 화면 등)
        return MaterialApp(
          // 앱의 제목을 'Numerology'라고 정해요.
          title: 'Numerology',
          // 앱의 밝은 모드 테마는 'themes.dart' 파일에 있는 'numerologyTheme'을 사용해요.
          theme: numerologyTheme,
          // 앱의 어두운 모드 테마는 'themes.dart' 파일에 있는 'numerologyDarkTheme'을 사용해요.
          darkTheme: numerologyDarkTheme, // 이 부분은 'themes.dart' 파일에 정의되어 있어요.
          // 앱의 현재 테마 모드(밝은지 어두운지)는 'themeProvider'에서 가져와요.
          themeMode: themeProvider.themeMode,
          // 앱에서 사용할 수 있는 언어들을 정의해요.
          supportedLocales: const [
            Locale('en', ''), // 영어
            Locale('ko', ''), // 한국어
          ],
          // 앱의 언어 설정을 관리하는 도구들을 등록해요.
          localizationsDelegates: const [
            AppLocalizations.delegate, // 앱에서 사용하는 문자열들을 관리하는 도구
            GlobalMaterialLocalizations.delegate, // Material Design 위젯의 문자열들을 관리하는 도구
            GlobalWidgetsLocalizations.delegate, // 위젯의 문자열들을 관리하는 도구
            GlobalCupertinoLocalizations.delegate, // iOS 스타일 위젯의 문자열들을 관리하는 도구
          ],
          // 현재 앱의 언어는 'localeProvider'에서 가져와요.
          locale: localeProvider.locale,
          // 앱이 처음 시작될 때 보여줄 화면은 'InputScreen'이에요.
          home: const InputScreen(),
        );
      },
    );
  }
}

// 사용자가 이름과 생년월일을 입력하는 화면이에요.
// 이 화면은 사용자의 입력에 따라 내용이 변할 수 있어서 'StatefulWidget'으로 만들었어요.
class InputScreen extends StatefulWidget {
  // 'InputScreen' 위젯을 만들 때 필요한 기본 정보예요.
  const InputScreen({super.key});

  // 이 화면의 상태를 관리하는 부분을 만들어요.
  @override
  State<InputScreen> createState() => _InputScreenState();
}

// 'InputScreen'의 실제 내용과 동작을 관리하는 부분이에요.
class _InputScreenState extends State<InputScreen> {
  // 이름을 입력받는 칸을 관리하는 도구예요.
  final _nameController = TextEditingController();
  // 사용자가 선택한 생년월일을 저장하는 곳이에요. 아직 선택하지 않았으면 비어있어요.
  DateTime? _selectedDate;
  // 계산 결과를 보여줄지 말지를 정하는 스위치예요. 처음에는 꺼져 있어요.
  bool _showResults = false;
  // 이전에 입력했던 이름과 날짜들을 저장하는 목록이에요. (최근 20개)
  List<Map<String, String>> _history = [];

  // 이 화면이 처음 만들어질 때 딱 한 번 실행되는 부분이에요.
  @override
  void initState() {
    super.initState(); // 부모 위젯의 시작 부분도 실행해줘요.
    _loadHistory(); // 앱을 껐다 켜도 기억하고 있는 이전 기록들을 불러와요.
  }

  // 앱을 껐다 켜도 기억하고 있는 이전 기록들을 불러오는 함수예요.
  Future<void> _loadHistory() async {
    // 앱의 정보를 저장하는 도구를 가져와요.
    final prefs = await SharedPreferences.getInstance();
    // 'history'라는 이름으로 저장된 글자 목록을 가져와요. 없으면 빈 목록을 가져와요.
    final historyString = prefs.getStringList('history') ?? [];
    // 화면의 내용을 바꿔줘요.
    setState(() {
      // 가져온 글자 목록을 하나씩 읽어서 이름과 날짜 정보로 바꿔서 '_history' 목록에 저장해요.
      _history = historyString
          .map((item) => Map<String, String>.from(json.decode(item)))
          .toList();
    });
  }

  // 현재 입력된 이름과 날짜를 기록으로 저장하는 함수예요.
  Future<void> _saveHistory() async {
    // 앱의 정보를 저장하는 도구를 가져와요.
    final prefs = await SharedPreferences.getInstance();
    // 지금 입력된 이름과 날짜를 새로운 기록으로 만들어요.
    final newEntry = {
      'name': _nameController.text,
      'date': _selectedDate!.toIso8601String(),
    };

    // 똑같은 기록이 있으면 목록에서 지워요. (중복을 막기 위해서예요)
    _history.removeWhere((item) => item['name'] == newEntry['name'] && item['date'] == newEntry['date']);
    // 가장 최근 기록을 목록 맨 앞에 추가해요.
    _history.insert(0, newEntry);

    // 기록이 20개가 넘으면 가장 오래된 기록들을 지워서 20개만 남겨요.
    if (_history.length > 20) {
      _history = _history.sublist(0, 20);
    }

    // 기록 목록을 컴퓨터가 저장할 수 있는 글자 형태로 바꿔요.
    final historyString = _history.map((item) => json.encode(item)).toList();
    // 바꾼 글자 목록을 'history'라는 이름으로 앱에 저장해요.
    await prefs.setStringList('history', historyString);
    _loadHistory(); // 기록을 다시 불러와서 화면에 바로 보이게 해요.
  }

  // 생년월일을 선택하는 달력 화면을 보여주는 함수예요.
  Future<void> _selectDate(BuildContext context) async {
    // 달력 화면을 띄워서 사용자가 날짜를 고르게 해요.
    final DateTime? picked = await showDatePicker(
      context: context,
      // 달력이 처음 열릴 때 보여줄 날짜예요. 이전에 선택한 날짜가 없으면 오늘 날짜를 보여줘요.
      initialDate: _selectedDate ?? DateTime.now(),
      // 선택할 수 있는 가장 오래된 날짜예요.
      firstDate: DateTime(1900),
      // 선택할 수 있는 가장 최근 날짜예요. (오늘 날짜)
      lastDate: DateTime.now(),
    );
    // 만약 사용자가 날짜를 골랐고, 이전에 선택한 날짜와 다르면
    if (picked != null && picked != _selectedDate) {
      // 화면의 내용을 바꿔줘요.
      setState(() {
        // 선택한 날짜를 저장해요.
        _selectedDate = picked;
      });
    }
  }

  // 'Calculate' 버튼을 눌렀을 때 실행되는 함수예요.
  void _calculate() {
    // 이름 칸이 비어있지 않고, 날짜도 선택되어 있으면
    if (_nameController.text.isNotEmpty && _selectedDate != null) {
      // 화면의 내용을 바꿔줘요.
      setState(() {
        // 계산 결과를 보여주도록 스위치를 켜요.
        _showResults = true;
      });
      _saveHistory(); // 현재 입력된 이름과 날짜를 기록으로 저장해요.
    } else {
      // 이름이나 날짜가 입력되지 않았으면 작은 알림 메시지를 화면 아래에 보여줘요.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseEnterNameAndBirthDate), // 알림 메시지 내용이에요.
        ),
      );
    }
  }

  // 'Back' 버튼을 눌렀을 때 실행되는 함수예요. 입력 화면으로 돌아가요.
  void _showInputScreen() {
    // 화면의 내용을 바꿔줘요.
    setState(() {
      // 계산 결과를 숨기고 입력 화면을 보여주도록 스위치를 꺼요.
      _showResults = false;
    });
  }

  // 'Reset' 버튼을 눌렀을 때 실행되는 함수예요. 입력된 내용을 모두 지워요.
  void _clearInput() {
    // 화면의 내용을 바꿔줘요.
    setState(() {
      // 이름 입력 칸의 글씨를 모두 지워요.
      _nameController.clear();
      // 선택된 날짜를 없애요.
      _selectedDate = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.inputReset),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // 기록 목록에서 항목을 눌렀을 때 실행되는 함수예요. 선택한 기록으로 입력 칸을 채워줘요.
  void _applyHistory(Map<String, String> entry) {
    // 화면의 내용을 바꿔줘요.
    setState(() {
      // 선택한 기록의 이름을 이름 입력 칸에 넣어요.
      _nameController.text = entry['name']!;
      // 선택한 기록의 날짜를 날짜 선택 칸에 넣어요.
      _selectedDate = DateTime.parse(entry['date']!);
    });
  }

  // 뒤로가기 버튼을 처리하는 함수
  Future<bool> _onWillPop() {
    // 만약 결과 화면이 보이고 있다면,
    if (_showResults) {
      // 화면을 다시 그려서
      setState(() {
        // 결과 화면을 숨기고 입력 화면을 보여줘요.
        _showResults = false;
      });
      // 앱이 종료되는 것을 막아요.
      return Future.value(false);
    }
    // 입력 화면이라면, 원래대로 뒤로가기를 해서 앱을 종료해요.
    return Future.value(true);
  }

  // 이 화면에 무엇을 그릴지 정하는 부분이에요.
  @override
  Widget build(BuildContext context) {
    // 화면에 보여줄 내용을 담을 변수예요.
    Widget bodyContent;

    // 만약 계산 결과를 보여주기로 되어 있으면
    if (_showResults) {
      // 결과 화면 내용을 만들어요.
      bodyContent = SingleChildScrollView(
        child: Column(
          // 내용들을 위에서 아래로 차례대로 쌓을 거예요.
          children: [
            // 'ResultScreen' 위젯을 만들어서 계산 결과를 보여줘요.
            ResultScreen(
              name: _nameController.text, // 현재 입력된 이름을 넘겨줘요.
              birthDate: _selectedDate!, // 현재 선택된 날짜를 넘겨줘요.
            ),
            const SizedBox(height: 16), // 버튼 위 여백
            // 'Back' 버튼을 만들어요.
            ElevatedButton(
              onPressed: _showInputScreen, // 버튼을 누르면 입력 화면으로 돌아가는 함수를 실행해요.
              child: Text(AppLocalizations.of(context)!.back), // 버튼에 'Back'이라고 써요.
            ),
            const SizedBox(height: 16), // 버튼 아래 여백
          ],
        ),
      );
    } else { // 계산 결과를 보여주지 않고 입력 화면을 보여줄 때
      // 입력 화면 내용을 만들어요.
      bodyContent = Padding(
        // 화면 가장자리에 16만큼의 여백을 줘요.
        padding: const EdgeInsets.all(16.0),
        // 내용들을 위에서 아래로 차례대로 쌓을 거예요.
        child: Column(
          // 내용들을 화면의 가운데에 놓아요.
          mainAxisAlignment: MainAxisAlignment.center,
          // 상자 안에 들어갈 내용들이에요.
          children: <Widget>[
            // 이름을 입력하는 칸을 만들어요.
            TextField(
              controller: _nameController, // 이 칸의 글씨는 '_nameController'가 관리해요.
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.name, // 칸 위에 'Name'이라고 써줘요.
              ),
            ),
            // 칸 아래에 20만큼의 빈 공간을 만들어요.
            const SizedBox(height: 20),
            // 날짜 선택 부분과 버튼을 가로로 나란히 놓을 거예요.
            Row(
              // 내용들을 위에서 아래로 차례대로 쌓을 거예요.
              children: [
                // 남은 공간을 모두 차지하도록 글씨 칸을 넓혀요.
                Expanded(
                  // 선택된 날짜를 보여주는 글씨를 만들어요.
                  child: Text(
                    // 날짜가 선택되지 않았으면 'No date chosen!'이라고 보여주고,
                    // 날짜가 선택되었으면 날짜만 간단히 보여줘요.
                    _selectedDate == null
                        ? AppLocalizations.of(context)!.noDateChosen
                        : _selectedDate!.toLocal().toString().split(' ')[0],
                  ),
                ),
                // 날짜를 선택하는 버튼을 만들어요.
                TextButton(
                  onPressed: () => _selectDate(context), // 버튼을 누르면 달력 화면을 보여주는 함수를 실행해요.
                  child: Text(AppLocalizations.of(context)!.chooseDate), // 버튼에 'Choose Date'라고 써요.
                ),
              ],
            ),
            // 날짜 선택 아래에 20만큼의 빈 공간을 만들어요.
            const SizedBox(height: 20),
            // 'Calculate' 버튼과 'Reset' 버튼을 가로로 나란히 놓을 거예요.
            Row(
              // 버튼들 사이에 같은 간격으로 공간을 만들어요.
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // 버튼들이에요.
              children: [
                // 'Calculate' 버튼을 만들어요.
                ElevatedButton(
                  onPressed: _calculate, // 버튼을 누르면 계산하는 함수를 실행해요.
                  child: Text(AppLocalizations.of(context)!.calculate), // 버튼에 'Calculate'라고 써요.
                ),
                // 'Reset' 버튼을 만들어요.
                ElevatedButton(
                  onPressed: _clearInput, // 버튼을 누르면 입력 내용을 지우는 함수를 실행해요.
                  child: Text(AppLocalizations.of(context)!.reset), // 버튼에 'Reset'이라고 써요.
                  // 'Reset' 버튼의 색깔을 빨간색으로 정해요.
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
            // 버튼 아래에 20만큼의 빈 공간을 만들어요.
            const SizedBox(height: 20),
            // 'History'라는 제목을 보여줘요.
            Text(AppLocalizations.of(context)!.history, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // 기록 목록이 화면의 남은 공간을 모두 차지하도록 넓혀요.
            Expanded(
              // 기록들을 목록 형태로 보여줘요. 스크롤도 가능해요.
              child: ListView.builder(
                // 기록 목록에 몇 개의 항목이 있는지 알려줘요.
                itemCount: _history.length,
                // 각 기록 항목을 어떻게 만들지 정해요.
                itemBuilder: (context, index) {
                  // 현재 만들 기록 항목의 정보를 가져와요.
                  final entry = _history[index];
                  // 한 줄짜리 목록 항목을 만들어요.
                  return ListTile(
                    // 항목의 제목은 기록된 이름이에요.
                    title: Text(entry['name']!),
                    // 항목의 부제목은 기록된 날짜예요. 시간 부분은 빼고 날짜만 보여줘요.
                    subtitle: Text(entry['date']!.split('T')[0]),
                    // 항목을 누르면 해당 기록으로 입력 칸을 채워주는 함수를 실행해요.
                    onTap: () => _applyHistory(entry),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // 앱의 기본 틀(아래쪽 메뉴바 같은 것)을 만들어서 화면 내용을 보여줘요.
    return CustomAppScreen(
      body: bodyContent, // 위에서 만든 화면 내용을 여기에 넣어요.
      onWillPop: _onWillPop, // 뒤로가기 처리 함수를 넘겨줘요.
    );
  }
}