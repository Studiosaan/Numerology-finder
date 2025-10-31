// 이 파일은 앱의 '설정' 화면을 만드는 코드예요.
// 여기서 앱의 여러 가지 설정을 바꿀 수 있어요.
import 'package:flutter/material.dart'; // Flutter 앱을 만드는 데 필요한 기본 도구들을 가져와요.
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart'; // 앱의 중요한 정보(테마 같은 것)를 여러 화면에서 함께 쓸 수 있게 도와주는 도구예요.
import 'package:numerology/theme_provider.dart'; // 앱의 테마(밝은 모드, 어두운 모드)를 관리하는 특별한 도구를 가져와요.
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // 앱의 다국어 문자열을 가져와요.
import 'package:numerology/locale_provider.dart'; // 앱의 언어 설정을 관리하는 도구를 가져와요.
import 'package:numerology/widgets/setting_card.dart'; // 설정 화면에 들어가는 한 줄짜리 카드를 만드는 위젯을 가져와요.
import 'package:url_launcher/url_launcher.dart'; // 웹사이트나 이메일 앱을 열어주는 라이브러리예요.

// '설정' 화면을 보여주는 위젯이에요.
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;
  final String _nativeAdUnitId = 'ca-app-pub-7332476431820224/5792684086';

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
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
        templateType: TemplateType.medium,
      ),
    )..load();
  }

  Future<void> _showAdAndNavigate(String url) async {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isKorean = localeProvider.locale?.languageCode == 'ko';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isKorean ? '커뮤니티로 이동' : 'Go to Community'),
          content: (_isNativeAdLoaded && _nativeAd != null)
              ? ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 300,
                  ),
                  child: AdWidget(ad: _nativeAd!),
                )
              : const SizedBox.shrink(),
          actions: <Widget>[
            TextButton(
              child: Text(isKorean ? '취소' : 'Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(isKorean ? '이동' : 'Go'),
              onPressed: () async {
                Navigator.of(context).pop();
                final Uri uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not launch $url'),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  // 이 함수는 화면에 무엇을 그릴지 정해줘요.
  @override
  Widget build(BuildContext context) {
    // 'ThemeProvider'라는 도구에서 현재 앱의 테마 정보를 가져와요.
    // 이 정보로 앱이 밝은 모드인지 어두운 모드인지 알 수 있어요.
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    // 화면 전체를 감싸는 큰 상자를 만들어요.
    return Container(
      // 상자 안쪽에 16만큼의 여백을 줘서 내용이 벽에 붙지 않게 해요.
      padding: const EdgeInsets.all(16.0),
      // 상자 안에 내용들을 위에서 아래로 차례대로 쌓을 거예요.
      child: Column(
        // 내용들을 왼쪽으로 정렬해요.
        crossAxisAlignment: CrossAxisAlignment.start,
        // 상자 안에 들어갈 내용들이에요.
        children: [
          // 글씨 아래에 20만큼의 빈 공간을 만들어요.
          const SizedBox(height: 20),
          // 다크 모드 설정 카드
          SettingCard(
            icon: Icons.dark_mode, // 다크 모드 아이콘
            title: AppLocalizations.of(context)!.darkMode, // '다크 모드' 제목
            iconColor: Colors.deepPurple,
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ),
          const SizedBox(height: 10), // 카드 사이 여백
          // 언어 설정 카드
          SettingCard(
            icon: Icons.language, // 언어 아이콘
            title: AppLocalizations.of(context)!.language, // '언어' 제목
            iconColor: Colors.blue,
            trailing: DropdownButton<Locale>(
              value: localeProvider.locale, // 현재 선택된 언어
              icon: const Icon(Icons.arrow_drop_down), // 드롭다운 아이콘
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  localeProvider.setLocale(newLocale);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.languageChanged(newLocale.languageCode == 'en' ? AppLocalizations.of(context)!.english : AppLocalizations.of(context)!.korean)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              items: const <DropdownMenuItem<Locale>>[
                DropdownMenuItem<Locale>(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem<Locale>(
                  value: Locale('ko'),
                  child: Text('한국어'),
                ),
              ],
            ),
          ),
          SettingCard(
              icon: Icons.coffee_outlined, // 네이버 카페를 상징하는 커피 아이콘
              title: AppLocalizations.of(context)!.community, // '커뮤니티' 제목
              iconColor: const Color(0xFF03C75A), // 네이버 녹색
              trailing: IconButton(
                // 오른쪽 끝에 버튼을 추가
                icon: const Icon(
                  Icons.arrow_forward_ios, // 오른쪽 화살표 아이콘
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _showAdAndNavigate('https://cafe.naver.com/shootingstarter');
                },
              ),
            ),
        ],
      ),
    );
  }
}