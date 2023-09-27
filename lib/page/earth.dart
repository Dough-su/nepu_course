import 'package:flutter/material.dart';
import 'package:muse_nepu_course/util/EarthAnimation.dart';
import 'package:muse_nepu_course/util/constants/colors.dart';
import 'package:muse_nepu_course/util/extension/screen_size.dart';
import 'package:muse_nepu_course/util/global.dart';
import 'package:muse_nepu_course/util/moving_earth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: SizedBox(
        width: context.getWidth,
        height: context.getHeight,
        child: Stack(
          children: [
            MovingEarth(
              animatePosition: EarthAnimation(
                topAfter: -150,
                topBefore: -150,
                leftAfter: -650,
                leftBefore: -800,
                bottomAfter: -150,
                bottomBefore: -150,
              ),
              delayInMs: 1000,
              durationInMs: 2500,
              child: GestureDetector(
                  onTap: () {
                    Global().jump_page(context);
                  },
                  child: Image.asset("assets/earth_home.jpg")),
            ),
            Positioned(
                left: 25,
                bottom: 20,
                right: 25,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontFamily: 'Proportional',
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w900,
                        fontSize: 25),
                    children: [
                       TextSpan(text: '欢迎来到'),
                      TextSpan(
                        text: '东油课表',
                        style: TextStyle(
                          fontFamily: 'Proportional',
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w900,
                          color: blue,
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}