import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:group_event/pages/auth_email.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}
class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: Image.asset('assets/images/logo.png',width: 60,)

          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Let\'s go right away!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Stay active",
          body:
          "It’s going to be a journey. It’s not a sprint to get in shape.” —Kerri Walsh Jennings",
          image:  Padding(
            padding: const EdgeInsets.all(50.0),
            child: ClipRRect(borderRadius: BorderRadius.circular(100),
                child: Image.network("https://static.nike.com/a/images/f_auto/dpr_3.0,cs_srgb/h_484,c_limit/b858f2bd-d574-4147-ad85-4fb7e6c397b6/how-to-find-your-optimal-running-paces.jpg")),
          ),

          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Soccer",
          body:
          "Soccer, also known as “The Beautiful Game,” has been a source of inspiration for millions of people around the world.",
          image:Padding(
            padding: const EdgeInsets.all(50.0),
            child: ClipRRect(borderRadius: BorderRadius.circular(100),
                child: Image.network("https://cdn.britannica.com/51/190751-131-B431C216/soccer-ball-goal.jpg")),
          ),
          // _buildImage('img2.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Volleyball",
          body:
          "Pass it better, set it higher, hit it harder",
          image:  Padding(
            padding: const EdgeInsets.all(50.0),
            child: ClipRRect(borderRadius: BorderRadius.circular(100),
                child: Image.network("https://asianvolleyball.net/new/wp-content/uploads/2019/06/1-38.jpg")),
          ),
          // _buildImage('img3.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Padel Tennis",
          body:
          "Combine action with fun and social interaction, an ideal game for men, women and youth to compete together.",
          image:   Padding(
            padding: const EdgeInsets.all(50.0),
            child: ClipRRect(borderRadius: BorderRadius.circular(100),
                child: Image.network("https://justpadel.ae/wp-content/uploads/2023/09/Playing-Tennis-padel-1.jpg")),
          ),

        ),
        PageViewModel(
          title: "Basketball",
          body: "Make a spectacular slam dunk.",
          image:  Padding(
            padding: const EdgeInsets.all(50.0),
            child: ClipRRect(borderRadius: BorderRadius.circular(100),
                child: Image.network("https://images2.minutemediacdn.com/image/upload/c_fill,w_720,ar_16:9,f_auto,q_auto,g_auto/shape/cover/sport/94e680f8be86214562e61fa6998ca2716ec132586a78b08c87a31a5666e24081.jpg")),
          ),
        ),
 
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}