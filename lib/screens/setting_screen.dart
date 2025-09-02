// 이 파일은 앱의 '설정' 화면을 만드는 코드예요.
// 여기서 앱의 여러 가지 설정을 바꿀 수 있어요.

import 'package:flutter/material.dart'; // Flutter 앱을 만드는 데 필요한 기본 도구들을 가져와요.
import 'package:provider/provider.dart'; // 앱의 중요한 정보(테마 같은 것)를 여러 화면에서 함께 쓸 수 있게 도와주는 도구예요.
import 'package:numerology/theme_provider.dart'; // 앱의 테마(밝은 모드, 어두운 모드)를 관리하는 특별한 도구를 가져와요.

// '설정' 화면을 보여주는 위젯이에요.
// 이 화면은 스스로 변하는 부분이 없어서 'StatelessWidget'으로 만들었어요.
class SettingScreen extends StatelessWidget {
  // 'SettingScreen' 위젯을 만들 때 필요한 기본 정보예요.
  const SettingScreen({super.key});

  // 이 함수는 화면에 무엇을 그릴지 정해줘요.
  @override
  Widget build(BuildContext context) {
    // 'ThemeProvider'라는 도구에서 현재 앱의 테마 정보를 가져와요.
    // 이 정보로 앱이 밝은 모드인지 어두운 모드인지 알 수 있어요.
    final themeProvider = Provider.of<ThemeProvider>(context);

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
          // 'Settings'라는 글씨를 보여줘요.
          Text(
            'Settings',
            // 글씨 크기와 스타일은 앱의 테마에서 정해진 'headlineMedium' 스타일을 따라요.
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          // 글씨 아래에 20만큼의 빈 공간을 만들어요.
          const SizedBox(height: 20),
          // 카드 모양의 상자를 만들어서 그 안에 '다크 모드' 스위치를 넣을 거예요.
          Card(
            // 카드 상자의 기본 여백을 없애요.
            margin: EdgeInsets.zero,
            // 카드 상자의 모서리를 둥글게 만들어요. 'InfoCard'와 똑같이 16만큼 둥글게 해요.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            // 카드 상자에 그림자 효과를 줘요. 'InfoCard'와 똑같이 5만큼 그림자를 줘요.
            elevation: 5,
            // 카드 상자 안쪽에 여백을 줘서 내용이 너무 붙지 않게 해요.
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              // '다크 모드'를 켜고 끌 수 있는 스위치 목록 항목을 만들어요.
              child: SwitchListTile(
                // 스위치 옆에 'Dark Mode'라는 글씨를 보여줘요.
                title: const Text('Dark Mode'),
                // 현재 앱이 어두운 모드인지 아닌지에 따라 스위치가 켜지거나 꺼져요.
                value: themeProvider.themeMode == ThemeMode.dark,
                // 스위치를 켜거나 끌 때 어떤 동작을 할지 정해요.
                onChanged: (value) {
                  // 'ThemeProvider' 도구에게 '다크 모드' 상태가 바뀌었다고 알려줘요.
                  themeProvider.toggleTheme(value);
                },
              ),
            ),
          ),
          // 언어 설정 부분은 지금은 사용하지 않아요. (사용자 요청으로 주석 처리했어요)
          /*
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('English'), // 실제 선택된 언어로 바꿔야 해요.
            onTap: () {
              // TODO: 언어 선택 기능을 여기에 만들 거예요.
            },
          ),
          */
        ],
      ),
    );
  }
}
