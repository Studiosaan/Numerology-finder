import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:numerology/screens/info_screen.dart';
import 'package:numerology/screens/setting_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
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
    {'title': 'Numerology Finder', 'icon': Icons.calculate},
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

    return WillPopScope(
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
    );
  }
}
