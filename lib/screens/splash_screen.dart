import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:numerology/services/history_service.dart';
import 'package:numerology/services/ad_service.dart';
import 'package:numerology/main.dart'; // InputScreen을 가져오기 위함

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 초기화 로직이 한 번만 실행되도록 플래그로 제어합니다.
    if (!_isInitialized) {
      _isInitialized = true;
      _initializeApp();
    }
  }

  // 메인 화면으로 이동하는 함수
  void _navigateToMainScreen() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const InputScreen()),
    );
  }

  Future<void> _initializeApp() async {
    // 1. HistoryService에서 기록 데이터를 백그라운드에서 로드합니다.
    await Provider.of<HistoryService>(context, listen: false).loadHistory();

    // 2. 디버그 모드인지 확인합니다.
    if (kDebugMode) {
      // 디버그 모드일 경우: 광고를 건너뛰고 바로 메인 화면으로 이동
      _navigateToMainScreen();
    } else {
      // 출시 모드일 경우: 스플래시 전면 광고를 로드하고 표시
      final adService = AdService();
      await adService.loadAndShowSplashAd(
        adUnitId: 'ca-app-pub-7332476431820224/9337504089',
        onAdDismissed: _navigateToMainScreen, // 광고가 닫히면 메인으로 이동
        onAdFailed: _navigateToMainScreen, // 광고 실패 시에도 메인으로 이동
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary, // 앱의 기본 색상으로 배경 설정
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white), // 로딩 인디케이터
              SizedBox(height: 20),
              Text(
                'Loading...', // 로딩 텍스트
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}