import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    _initializeAndShowAd();
  }

  Future<void> _initializeAndShowAd() async {
    // 위젯 트리가 완전히 빌드된 후 context에 접근할 수 있도록 작은 지연을 줍니다.
    await Future.delayed(Duration.zero);

    // 1. HistoryService에서 기록 데이터를 백그라운드에서 로드합니다.
    await Provider.of<HistoryService>(context, listen: false).loadHistory();

    // 2. 스플래시 전면 광고를 로드하고 표시합니다.
    final adService = AdService(); // 스플래시 전용 AdService 인스턴스 생성
    await adService.loadAndShowSplashAd(
      adUnitId: 'ca-app-pub-7332476431820224/9337504089', // 요청하신 광고 ID
      onAdDismissed: () {
        // 광고가 닫히면 메인 화면으로 이동합니다.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const InputScreen()),
        );
      },
      onAdFailed: () {
        // 광고 로드 또는 표시에 실패해도 메인 화면으로 이동합니다.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const InputScreen()),
        );
      },
    );
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