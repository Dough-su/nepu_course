
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'flip_layout.dart';

/// =====================================================
//region Carousel test
class AnimatedFlip extends StatefulWidget {
  final Widget child;
  final Widget? back;

  AnimatedFlip({
    required this.child,
    this.back,
  });

  @override
  _AnimatedFlipState createState() => _AnimatedFlipState();
}

class _AnimatedFlipState extends State<AnimatedFlip> with SingleTickerProviderStateMixin {
  late AnimationController _animationControl;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationControl = AnimationController(vsync: this, duration: Duration(seconds: 6));
    // _animation = _animationControl.drive(Tween(begin: 0, end: .5)); //首个
    // _animation = _animationControl.drive(Tween(begin: -.50,end: .5));//中间
    _animation = _animationControl.drive(Tween(begin: -.5, end: 0)); //最后
    // _animation = _animationControl.drive(Tween(begin: -.5, end: .5)); //
    _animationControl.repeat();
  }

  @override
  void dispose() {
    _animationControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Flip(
          back: widget.back,
          child: widget.child,
          // spinProgress: 0.3,
          spinProgress: _animation.value,
        );
      },
    );
  }
}
//endregion

/// ======================== demo ==================
//region CarouselLayoutDemo
class CarouselLayoutDemo extends StatelessWidget {
  List<String> titles = [
    "Fold",
    "Arithmetic",
    "SnowMain",
    // "BlendokuPage",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(50),
          color: Colors.yellowAccent,
          // child: buildAnimatedCarousel(),
          child: buildListView(),
        ));
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, int inde) {
        return FlipLayout(
            key: ValueKey(inde),
            foldState: inde != 0,
            children: List.generate(titles.length, (index) {
              if (index == 0) {
                return Container(
                  width: 200,
                  height: 100,
                  child: Builder(
                    builder: (BuildContext context) => centerText(titles[index], color: Colors.primaries[index], onPressed: () {
                      FlipLayout.of(context).toggle();
                    }),
                  ),
                );
              } else {
                return centerTextButton(titles[index], color: Colors.primaries[index], onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(titles[index])));
                });
              }
            }),
            foldChild: Builder(builder: (context) {
              return Container(
                child: centerText("Unfold", color: Colors.primaries[6], onPressed: () {
                  FlipLayout.of(context).toggle();
                }),
              );
            }));
      },
    );
  }

  Container centerText(String text, {Color? color, VoidCallback? onPressed}) {
    return Container(
      width: 200,
      height: 100,
      padding: EdgeInsets.all(30),
      color: color,
      child: Container(child: onPressed == null ? Text(text) : ElevatedButton(onPressed: onPressed, child: Text(text))),
    );
  }

  Container centerTextButton(String text, {Color? color, VoidCallback? onPressed}) {
    return Container(
      width: 200,
      height: 100,
      padding: EdgeInsets.all(30),
      color: color,
      child: Container(
        child: onPressed == null ? Text(text) : TextButton(onPressed: onPressed, child: Text(text)),
      ),
    );
  }
}
//endregion
