import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///  首个，  ===  > __|  反面反转正面不变 （围绕底部旋转 0->0.5）  0.5的时候背面不可见
///  中间， |__(围绕顶部旋转 -0.5->0)   >  ===  >  __|(围绕底部旋转 0->0.5)  反面反转，正面(后半部分可见)不翻转
///  末尾,  |  >  ___  (围绕顶部旋转 -0.5->0) 只要正面只旋转正面
///
class FoldingBox extends StatefulWidget {
  final List<Container>? children;
  final Decoration? decoration;
  final bool foldState;
  final Container? foldChild;
  final Color backgroundColor;
  final Widget? background;
  final BorderRadius? borderRadius;

  const FoldingBox(
      {Key? key,
      this.children,
      this.foldChild,
      this.foldState = false,
      this.decoration,
      this.borderRadius,
      this.backgroundColor = Colors.white,
      this.background})
      : super(key: key);

  static FoldingBoxState of(BuildContext context) {
    return context.findAncestorStateOfType<FoldingBoxState>()!;
  }

  @override
  FoldingBoxState createState() => FoldingBoxState();
}

class FoldingBoxState extends State<FoldingBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationControl;
  late List<Animation<double>> _unfoldAnimations;
  late Animation<double> _heightAnimation;
  var childSize = 0;
  double aniChangeHeight = 0;
  double minHeight = 0;

  void toggle() {
    if (_animationControl.value == 1) {
      _animationControl.reverse();
    } else {
      _animationControl.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    aniChangeHeight = widget.children!
        .map((e) => e.constraints!.maxHeight)
        .reduce((value, element) => value + element);
    minHeight = widget.children!.first.constraints!.maxHeight;
    aniChangeHeight = aniChangeHeight - minHeight;
    childSize = widget.children!.length;
    Animation<double>? unfoldAnimation;
    if (childSize <= 3) {
      _animationControl = AnimationController(
          vsync: this, duration: const Duration(seconds: 1));
    } else {
      _animationControl = AnimationController(
          vsync: this,
          duration: Duration(seconds: 2 * (childSize / 3).floor()));
    }

    /// 0--1 折叠 --> 展开  0为折叠状态
    unfoldAnimation = Tween(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_animationControl);
    if (widget.foldState) {
      unfoldAnimation =
          _animationControl.drive(CurveTween(curve: Curves.easeInOut));
    }
    _heightAnimation = CurvedAnimation(
        parent: unfoldAnimation, curve: const Cubic(0.75, 0.82, 0.08, 1.15));

    if (childSize > 1) {
      double interval = 1.0 / (childSize);
      _unfoldAnimations = List.generate(childSize, (index) {
        double begin, end = 0;
        if (index == 0) {
          begin = 0;
          end = 0.5;
        } else if (index == childSize - 1) {
          begin = -.5;
          end = 0;
        } else {
          begin = -.5;
          end = .5;
        }
        Tween<double> foldTween = Tween(begin: begin, end: end);
        return foldTween
            .chain(CurveTween(
                curve: Interval(index * interval, (index + 1) * interval)))
            .animate(unfoldAnimation!);
      });
    } else {
      _unfoldAnimations = [unfoldAnimation];
    }
  }

  @override
  void dispose() {
    _animationControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = AnimatedBuilder(
      animation: _animationControl,
      builder: (BuildContext context, Widget? child) {
        return foldAbleLayout(context);
      },
    );

    if (widget.borderRadius != null) {
      result = ClipRRect(
        borderRadius: widget.borderRadius,
        child: result,
      );
    }
    return result;
  }

  /// 折叠到展开  0-1
  /// 1, 围绕底部旋转 0-90     折叠状态 0
  /// 2，围绕顶部 90-0(-0>-90)，，围绕底部 0-90(要显示holder)  折叠状态 -90
  /// 3，围绕顶部 90-0     折叠状态 90 ---> 0 折叠到展开
  foldAbleLayout(BuildContext context) {
    return Container(
      decoration: widget.decoration,
      height: minHeight + aniChangeHeight * (_heightAnimation.value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(childSize, (index) {
          Container child = widget.children![index];
          if (index == 0) {
            return Stack(
              fit: StackFit.passthrough,
              children: [
                child,
                FlipBox(
                  animation: _unfoldAnimations[index],
                  child: widget.foldChild!,
                ),
              ],
            );
          }
          if (index == childSize - 1) {
            return FlipBox(
              animation: _unfoldAnimations[index],
              child: child,
            );
          }
          var background = widget.background ??
              Container(
                width: child.constraints!.maxWidth,
                height: child.constraints!.maxHeight,
                color: widget.backgroundColor,
              );
          return FlipBox(
            animation: _unfoldAnimations[index],
            child: background,
            holderChild: child,
          );
        }),
      ),
    );
  }
}

/// 折叠到展开  0-1
/// 1, 围绕底部旋转 0-90     折叠状态 0
/// 2，围绕顶部 90-0(-0>-90)，，围绕底部 0-90(要显示holder)  折叠状态 -90
/// 3，围绕顶部 90-0     折叠状态 90
// class FlipBox extends AnimatedWidget {
@immutable
class FlipBox extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final Widget? holderChild;

  const FlipBox({
    Key? key,
    required this.animation,
    this.holderChild,
    required this.child,
  }) : super(key: key);

  /// 折叠到展开  0-1
  /// 1, 围绕底部旋转 0-90     折叠状态 0           0,0.5
  /// 2，围绕顶部 90-0(-90>0)，，围绕底部 0-90(要显示holder)  折叠状态 -90  -.5,.5
  /// 3，围绕顶部 90-0     折叠状态 90           -.5,0
  @override
  Widget build(BuildContext context) {
    double progress = animation.value;
    if (progress == -.5) {
      ///折叠起来之后就不需要占位置了
      return const SizedBox.shrink();
    }

    if (holderChild != null && progress > 0) {
      return Stack(
        children: [
          holderChild!, //显示正面view
          Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(
                    progress < 0 ? -progress.abs() * pi : progress.abs() * pi),
              alignment: progress < 0
                  ? AlignmentDirectional.topCenter
                  : AlignmentDirectional.bottomCenter,
              child: child),
        ],
      );
    }
    return Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(progress < 0 ? -progress.abs() * pi : progress.abs() * pi),
        alignment: progress < 0
            ? AlignmentDirectional.topCenter
            : AlignmentDirectional.bottomCenter,
        child: child);
  }
}
