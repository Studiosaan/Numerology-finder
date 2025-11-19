// 이 파일은 앱의 가장 중요한 부분이에요. 앱이 어떻게 시작되고, 어떤 화면들을 보여줄지 정해요.

import 'package:flutter/material.dart'; // Flutter 앱을 만드는 데 필요한 기본 도구들을 가져와요.
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:numerology/locale_provider.dart';
import 'package:numerology/screens/result_screen.dart'; // 계산 결과를 보여주는 화면 코드를 가져와요.
import 'package:numerology/themes.dart'; // 앱의 색깔과 글씨 모양을 정하는 코드들을 가져와요.
import 'package:numerology/widgets/custom_app_screen.dart'; // 앱의 기본 틀(아래쪽 메뉴바 같은 것)을 만드는 코드를 가져와요.
import 'package:provider/provider.dart'; // 앱의 중요한 정보(테마 같은 것)를 여러 화면에서 함께 쓸 수 있게 도와주는 도구예요.
import 'package:numerology/theme_provider.dart'; // 앱의 테마(밝은 모드, 어두운 모드)를 관리하는 특별한 도구를 가져와요.
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:numerology/services/ad_service.dart';
import 'package:numerology/services/history_service.dart';
import 'package:numerology/screens/splash_screen.dart'; // 스플래시 화면 임포트

import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';

// 앱이 처음 시작될 때 가장 먼저 실행되는 부분이에요.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // 앱을 화면에 보여줘요.
  runApp(
    // 여러 Provider를 함께 사용할 수 있게 해주는 MultiProvider를 사용해요.
    MultiProvider(
      providers: [
        // 'ThemeProvider'라는 도구를 앱 전체에서 사용할 수 있게 해줘요.
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        // 'LocaleProvider'라는 도구를 앱 전체에서 사용할 수 있게 해줘요.
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        // 'HistoryService'를 앱 전체에서 사용할 수 있게 합니다.
        ChangeNotifierProvider(create: (context) => HistoryService()),
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
          title: '수비학 계산기',
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
            GlobalMaterialLocalizations
                .delegate, // Material Design 위젯의 문자열들을 관리하는 도구
            GlobalWidgetsLocalizations.delegate, // 위젯의 문자열들을 관리하는 도구
            GlobalCupertinoLocalizations.delegate, // iOS 스타일 위젯의 문자열들을 관리하는 도구
          ],
          // 현재 앱의 언어는 'localeProvider'에서 가져와요.
          locale: localeProvider.locale,
          // 앱이 처음 시작될 때 보여줄 화면은 'InputScreen'이에요.
          home: const SplashScreen(), // 시작 화면을 SplashScreen으로 변경
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

  // 서비스 인스턴스
  late final HistoryService _historyService;
  late final AdService _adService;

  // 네이티브 광고
  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;
  final String _nativeAdUnitId = 'ca-app-pub-7332476431820224/5792684086';

  // 이 화면이 처음 만들어질 때 딱 한 번 실행되는 부분이에요.
  @override
  void initState() {
    super.initState(); // 부모 위젯의 시작 부분도 실행해줘요.
    // Provider를 통해 서비스 인스턴스를 가져옵니다.
    _historyService = Provider.of<HistoryService>(context, listen: false);
    _historyService.loadHistory(); // 기록 불러오기

    _adService = AdService();
    _adService.initialize(); // 광고 서비스 초기화
    _loadNativeAd();
  }

  void _loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: _nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isNativeAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Native ad failed to load: $error');
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium, // or TemplateType.small
      ),
    )..load();
  }

  @override
  void dispose() {
    _adService.dispose();
    _nameController.dispose();
    _nativeAd?.dispose();
    super.dispose();
  }

  // 결과 화면을 표시하고 기록을 저장하는 함수
  void _showResultScreenAndSaveHistory() {
    final newEntry = {
      'name': _nameController.text,
      'date': _selectedDate?.toIso8601String() ?? '',
    };
    _historyService.addOrUpdateEntry(newEntry);

    setState(() {
      _showResults = true;
    });
  }

  // 생년월일을 선택하는 달력 화면을 보여주는 함수예요.
  Future<void> _selectDate(BuildContext context) async {
    // 달력 화면을 띄워서 사용자가 날짜를 고르게 해요.
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _calculate() async {
    // 이름 칸이 비어있지 않으면 (날짜는 없어도 됨)
    if (_nameController.text.isNotEmpty) {
      // 광고 표시 여부를 확인하고, 광고가 표시되지 않은 경우에만 즉시 결과 화면으로 이동
      final adShown = await _adService.showAdIfNeeded(() {
        _showResultScreenAndSaveHistory(); // 광고가 닫힌 후 실행될 콜백
      });
      if (!adShown) {
        _showResultScreenAndSaveHistory(); // 광고가 없으면 바로 결과 표시
      }
    } else {
      // 이름이 입력되지 않았으면 작은 알림 메시지를 화면 아래에 보여줘요.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.pleaseEnterNameAndBirthDate,
          ), // 알림 메시지 내용이에요.
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

  // 기록 목록에서 항목을 눌렀을 때 실행되는 함수예요. 선택한 기록으로 입력 칸을 채우고, 기록을 맨 위로 올립니다.
  void _applyHistory(Map<String, String> entry) {
    // 화면의 내용을 바꿔줘요.
    _historyService.addOrUpdateEntry(entry); // 기록을 업데이트 (최상단으로 이동)
    setState(() {
      // 선택한 기록의 이름을 이름 입력 칸에 넣어요.
      _nameController.text = entry['name']!;
      // 선택한 기록의 날짜를 날짜 선택 칸에 넣어요.
      if (entry['date'] != null && entry['date']!.isNotEmpty) {
        _selectedDate = DateTime.parse(entry['date']!);
      } else {
        _selectedDate = null;
      }
    });
  }

  // 뒤로가기 버튼을 처리하는 함수
  Future<bool> _onWillPop() async {
    if (_showResults) {
      setState(() {
        _showResults = false;
      });
      return false;
    } else {
      final bool? shouldPop = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('정말 나가시겠습니까?'),
              content:
                  (_isNativeAdLoaded && _nativeAd != null)
                      ? ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 300, // Adjust height as needed
                        ),
                        child: AdWidget(ad: _nativeAd!),
                      )
                      : const SizedBox.shrink(),
              actions: [
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: Text('종료'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    InAppReview.instance.openStoreListing(
                      appStoreId:
                          'YOUR_APP_STORE_ID', // TODO: Add your App Store ID
                      microsoftStoreId:
                          'YOUR_MICROSOFT_STORE_ID', // TODO: Add your Microsoft Store ID
                    );
                  },
                  child: Text('리뷰하기'),
                ),
              ],
            ),
      );
      return shouldPop ?? false;
    }
  }

  // 이 화면에 무엇을 그릴지 정하는 부분이에요.
  @override
  Widget build(BuildContext context) {
    // HistoryService의 변경사항을 감지하여 UI를 다시 그립니다.
    final history = context.watch<HistoryService>().history;

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
              birthDate: _selectedDate, // 현재 선택된 날짜를 넘겨줘요. (없으면 null)
            ),
            const SizedBox(height: 16), // 버튼 위 여백
            // 'Back' 버튼을 만들어요.
            ElevatedButton(
              onPressed: _showInputScreen, // 버튼을 누르면 입력 화면으로 돌아가는 함수를 실행해요.
              child: Text(
                AppLocalizations.of(context)!.back,
              ), // 버튼에 'Back'이라고 써요.
            ),
            const SizedBox(height: 16), // 버튼 아래 여백
          ],
        ),
      );
    } else {
      // 계산 결과를 보여주지 않고 입력 화면을 보여줄 때
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
                labelText:
                    AppLocalizations.of(context)!.name, // 칸 위에 'Name'이라고 써줘요.
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
                  onPressed:
                      () =>
                          _selectDate(context), // 버튼을 누르면 달력 화면을 보여주는 함수를 실행해요.
                  child: Text(
                    AppLocalizations.of(context)!.chooseDate,
                  ), // 버튼에 'Choose Date'라고 써요.
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
                  child: Text(
                    AppLocalizations.of(context)!.calculate,
                  ), // 버튼에 'Calculate'라고 써요.
                ),
                // 'Reset' 버튼을 만들어요.
                ElevatedButton(
                  onPressed: _clearInput, // 버튼을 누르면 입력 내용을 지우는 함수를 실행해요.
                  child: Text(
                    AppLocalizations.of(context)!.reset,
                  ), // 버튼에 'Reset'이라고 써요.
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
            Text(
              AppLocalizations.of(context)!.history,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // 기록 목록이 화면의 남은 공간을 모두 차지하도록 넓혀요.
            Expanded(
              // 기록들을 목록 형태로 보여줘요. 스크롤도 가능해요.
              child: ListView.builder(
                // 기록 목록에 몇 개의 항목이 있는지 알려줘요.
                itemCount: history.length,
                // 각 기록 항목을 어떻게 만들지 정해요.
                itemBuilder: (context, index) {
                  // 현재 만들 기록 항목의 정보를 가져와요.
                  final entry = history[index];
                  // 입체적인 카드 형태로 기록 항목을 만듭니다.
                  return Card(
                    elevation: 4.0, // 카드의 그림자 깊이
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 4.0,
                    ), // 카드 간 여백
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // 모서리를 둥글게
                    ),
                    child: ListTile(
                      title: Text(entry['name']!), // 항목의 제목은 기록된 이름
                      subtitle: Text(
                        (entry['date'] != null && entry['date']!.isNotEmpty)
                            ? entry['date']!.split('T')[0]
                            : 'No Date', // 날짜가 없으면 'No Date' 표시
                      ), // 부제목은 날짜
                      onTap: () => _applyHistory(entry), // 항목을 누르면 입력 칸에 적용
                      // 오른쪽 끝에 입체적인 'X' 버튼을 추가합니다.
                      trailing: InkWell(
                        onTap:
                            () => _historyService.deleteEntry(
                              index,
                            ), // 누르면 삭제 함수 실행
                        borderRadius: BorderRadius.circular(
                          15,
                        ), // 물결 효과를 위한 둥근 모서리
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(
                                  context,
                                ).scaffoldBackgroundColor, // 배경색
                            shape: BoxShape.circle, // 원형 모양
                            boxShadow: [
                              // 입체감을 위한 그림자
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
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
