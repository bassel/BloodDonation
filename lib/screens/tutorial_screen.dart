import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

import '../common/assets.dart';
import '../common/colors.dart';
import '../common/hive_boxes.dart';
import 'login_screen.dart';

class TutorialScreen extends StatefulWidget {
  static const route = 'tutorial';
  const TutorialScreen({Key key}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with SingleTickerProviderStateMixin {
  final _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.page.round() != _currentIndex) {
        setState(() => _currentIndex = _controller.page.round());
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                children: const [
                  _TutorialPanel(
                    asset: IconAssets.bloodHand,
                    title: 'Request Blood',
                    body: 'Submit a blood request and let the donors know!',
                  ),
                  _TutorialPanel(
                    asset: IconAssets.bloodBagHand,
                    title: 'Donate Blood',
                    body: 'Browse the requests and check if you can help by '
                        'donating blood to those who need it',
                  ),
                  _TutorialPanel(
                    asset: IconAssets.clipboard,
                    title: 'Health Information',
                    body: 'Stay updated with the latest health tips and '
                        'information',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: DotsIndicator(
                dotsCount: 3,
                decorator: const DotsDecorator(
                  activeColor: MainColors.primary,
                  size: Size.square(12),
                  activeSize: Size.square(12),
                ),
                position: _currentIndex * 1.0,
              ),
            ),
            InkWell(
              onTap: () {
                if (_currentIndex == 2) {
                  Hive.box(ConfigBox.key).put(ConfigBox.isFirstLaunch, false);
                  Navigator.of(context).pushReplacementNamed(LoginScreen.route);
                } else {
                  _controller.animateToPage(
                    _currentIndex + 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.decelerate,
                  );
                }
              },
              child: Ink(
                color: MainColors.primary,
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: Text(
                  _currentIndex == 2 ? "Let's go!" : 'Next',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorialPanel extends StatelessWidget {
  final String asset, title, body;

  const _TutorialPanel({
    Key key,
    @required this.asset,
    @required this.title,
    @required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 42),
            child: SvgPicture.asset(
              asset,
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
          Text(
            title,
            style: textTheme.headline4.copyWith(
              color: MainColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            body,
            textAlign: TextAlign.center,
            style: textTheme.headline3.copyWith(fontSize: 18, height: 1.2),
          ),
        ],
      ),
    );
  }
}
