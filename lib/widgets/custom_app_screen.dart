import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:numerology/locale_provider.dart';
import 'package:numerology/screens/info_screen.dart';
import 'package:numerology/screens/setting_screen.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

class CustomAppScreen extends StatefulWidget {
  final Widget body;
  final Future<bool> Function()? onWillPop;

  const CustomAppScreen({
    super.key,
    required this.body,
    this.onWillPop,
  });

  @override
  State<CustomAppScreen> createState() => _CustomAppScreenState();
}

class _CustomAppScreenState extends State<CustomAppScreen> {
  int _selectedIndex = 0;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  late Upgrader upgrader;
  bool _upgraderInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  @override
  void didChangeDependencies() {
    // upgrader는 딱 한 번만 초기화되도록 '깃발'로 체크합니다.
    if (!_upgraderInitialized) {
      final localeProvider = Provider.of<LocaleProvider>(context);
      final languageCode = localeProvider.locale?.languageCode ?? 'en';

      upgrader = Upgrader(
        messages: AppUpgraderMessages(languageCode),

        // [수정됨] '나중에', '무시' 버튼 테스트를 위해 이 줄을 주석 처리했습니다.
        // minAppVersion: '99.0.0',

        // [중요!] 테스트가 끝나면 이 줄을 지우거나 주석 처리하세요.
        // debugDisplayAlways: true,

        debugLogging: true,
      );

      // '깃발'을 true로 바꿔서 다시 초기화되지 않도록 합니다.
      _upgraderInitialized = true;
    }

    super.didChangeDependencies();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7332476431820224/7832850720', // 실제 광고 ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Map<String, dynamic>> _appBarOptions = <Map<String, dynamic>>[
    {'title': 'Numerology Calculator', 'icon': Icons.calculate},
    {'title': 'Settings', 'icon': Icons.settings},
    {'title': 'Info', 'icon': Icons.info_outline},
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      widget.body,
      const SettingScreen(),
      const InfoScreen(),
    ];

    return UpgradeAlert(
      upgrader: upgrader,
      
      // [수정됨] 'Later' 버튼을 표시하지 않도록 false로 변경했습니다.
      showLater: false, 
      
      showIgnore: true, // 'Ignore' 버튼은 계속 표시합니다.
      child: WillPopScope(
        onWillPop: widget.onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Icon(
                  _appBarOptions[_selectedIndex]['icon'] as IconData,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  _appBarOptions[_selectedIndex]['title'] as String,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            elevation: Theme.of(context).appBarTheme.elevation,
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.background,
                        Theme.of(context).colorScheme.surface,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: _widgetOptions.elementAt(_selectedIndex),
                  ),
                ),
              ),
              if (_isBannerAdLoaded)
                SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: '세팅',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline),
                label: '인포',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class AppUpgraderMessages extends UpgraderMessages {
  /// 현재 앱의 언어 코드 (예: 'ko', 'en')
  final String languageCode;
  AppUpgraderMessages(this.languageCode);

  @override
  String get title {
    if (languageCode == 'ko') {
      return '앱 업데이트';
    }
    // 기본값 (영어)
    return 'New Version Available';
  }

  @override
  String get body {
    if (languageCode == 'ko') {
      return '더욱 안정적이고,\n정확한 보이드를 체크해보세요.';
    }
    // 기본값 (영어)
    return 'Experience a more stable and new app.';
  }

  @override
  String get prompt {
    if (languageCode == 'ko') {
      return '지금 업데이트하시겠습니까?';
    }
    // 기본값 (영어)
    return 'Would you like to update now?';
  }

  @override
  String get buttonTitleUpdate {
    if (languageCode == 'ko') {
      return '지금 업데이트';
    }
    // 기본값 (영어)
    return 'Update Now';
  }

  @override
  String get buttonTitleIgnore {
    if (languageCode == 'ko') {
      return '이 버전 무시'; 
    }
    // 기본값 (영어)
    return 'Ignore';
  }

  @override
  String get buttonTitleLater {
    if (languageCode == 'ko') {
      return '나중에';
    }
    // 기본값 (영어)
    return 'Later';
  }
}