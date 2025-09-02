// 이 파일은 앱의 '정보' 화면을 만드는 코드를 담고 있어요.
// 앱을 만든 사람, 앱이 유용한 사람, 앱을 만든 이유 등 여러 정보를 보여주는 화면이에요.

import 'package:flutter/material.dart'; // Flutter 앱의 기본 위젯들을 가져와요.
import '../widgets/info_card.dart'; // 정보 화면에 보이는 카드 모양 위젯을 가져와요.

// 정보 화면을 보여주는 위젯이에요.
class InfoScreen extends StatelessWidget {
  // 이 위젯은 변하지 않는 내용을 보여줘서 StatelessWidget으로 만들었어요.
  const InfoScreen({super.key}); // 위젯을 만들 때 필요한 기본 정보예요.

  // 이 함수는 화면에 무엇을 그릴지 정해줘요.
  @override
  Widget build(BuildContext context) {
    // 화면의 나머지 부분을 채워요.
    return Container(
      width: double.infinity, // 화면의 가로 길이를 최대한 넓게 만들어요.
      height: double.infinity, // 화면의 세로 길이를 최대한 넓게 만들어요.
      decoration: BoxDecoration(
        // 화면의 배경에 색깔이 서서히 변하는 효과를 줄 거예요.
        gradient: LinearGradient(
          begin: Alignment.topCenter, // 위쪽부터
          end: Alignment.bottomCenter, // 아래쪽까지
          colors: [
            // 앱의 배경색과 표면색을 이용해 자연스럽게 색이 바뀌도록 해요.
            Theme.of(context).colorScheme.background,
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      // 화면이 폰의 노치(카메라 등)에 가려지지 않게 해줘요.
      child: SafeArea(
        // 내용이 많아지면 스크롤 할 수 있도록 해줘요.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0), // 내용 가장자리로부터 20만큼 떨어뜨려요.
          child: Column(
            // 카드들을 위에서 아래로 차례대로 쌓을 거예요.
            children: [
              // 첫 번째 정보 카드: 앱을 만든 사람
              const InfoCard(
                icon: Icons.people, // 사람 아이콘을 보여줘요.
                title: '우리는 누구인가요', // '우리는 누구인가요?'라는 제목을 보여줘요.
                subtitle: '• 아리온아인의 사명 : \n사자의 눈으로 세상을 헤아립니다', // 이 앱을 만든 사람에 대한 설명을 보여줘요.
                iconColor: Colors.amber, // 아이콘 색깔을 호박색으로 정해요.
              ),
              const SizedBox(height: 20), // 카드 사이에 20만큼의 공간을 만들어요.
              // 두 번째 정보 카드: 앱이 유용한 사람
              const InfoCard(
                icon: Icons.timer_sharp, // 시계 아이콘을 보여줘요.
                title: '누구에게 유용한가요?', // '이 앱이 유용한 사람은?'이라는 제목을 보여줘요.
                subtitle: '• 수비학에 대해 궁금하거나, 자신과 타인의 성향을 숫자를 통해 이해하고 싶은 모든 분들', // 이 앱을 쓰면 좋은 사람에 대한 설명을 보여줘요.
                iconColor: Colors.green, // 아이콘 색깔을 초록색으로 정해요.
              ),
              const SizedBox(height: 20), // 카드 사이에 20만큼의 공간을 만들어요.
              // 세 번째 정보 카드: 앱을 만든 이유
              const InfoCard(
                icon: Icons.app_shortcut, // 앱 아이콘을 보여줘요.
                title: '왜 이 앱을 만들었나요?', // '왜 이 앱을 만들었나요?'라는 제목을 보여줘요.
                subtitle: '• 누구나 손쉽게 이 정보들에 접근 가능하면 좋겠다는 마음에', // 이 앱을 만든 이유에 대한 설명을 보여줘요.
                iconColor: Colors.purple, // 아이콘 색깔을 보라색으로 정해요.
              ),
              const SizedBox(height: 20), // 카드 사이에 20만큼의 공간을 만들어요.
              // 저작권 정보를 담을 상자를 만들어요.
              Container(
                padding: const EdgeInsets.all(10), // 상자 안쪽에 10만큼 공간을 줘요.
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor, // 카드와 같은 배경색을 써요.
                  borderRadius: BorderRadius.circular(16), // 모서리를 둥글게 만들어요.
                  boxShadow: [
                    // 상자 아래에 그림자 효과를 줘요.
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.1), // 그림자 색깔을 투명하게 해요.
                      blurRadius: 10, // 그림자를 흐릿하게 만들어요.
                      offset: const Offset(0, 5), // 그림자를 아래쪽으로 5만큼 옮겨요.
                    ),
                  ],
                ),
                child: Text(
                  ' 2025 Arion Ayin. All rights reserved.', // 저작권 글씨를 직접 사용해요.
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7), // 글씨색을 살짝 흐리게 해요.
                    fontSize: 12, // 글씨 크기를 12로 작게 만들어요.
                    fontStyle: FontStyle.italic, // 글씨체를 기울이게 해요.
                  ),
                  textAlign: TextAlign.center, // 글씨를 가운데에 놓아요.
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
