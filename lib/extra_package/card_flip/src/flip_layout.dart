import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

///  首个，  ===  > __|  反面反转正面不变 （围绕底部旋转 0->0.5）  0.5的时候背面不可见
///  中间， |__(围绕顶部旋转 -0.5->0)   >  ===  >  __|(围绕底部旋转 0->0.5)  反面反转，正面(后半部分可见)不翻转
///  末尾,  |  >  ___  (围绕顶部旋转 -0.5->0) 只要正面只旋转正面
///
class FlipLayout extends StatefulWidget {
  final List<Widget>? children;
  final Decoration? decoration;
  final bool foldState; //折叠状态 true 0-1展开
  final Widget? foldChild;
  final Color backgroundColor;
  final Widget? background;
  final BorderRadius? borderRadius;
  final int duration;

  const FlipLayout({
    Key? key,
    this.children,
    this.foldChild,
    this.foldState = false,
    this.decoration,
    this.duration = 1000,
    this.borderRadius,
    this.backgroundColor = Colors.grey,
    this.background,
  }) : super(key: key);

  static FlipLayoutState of(BuildContext context) {
    return context.findAncestorStateOfType<FlipLayoutState>()!;
  }

  @override
  FlipLayoutState createState() => FlipLayoutState();
}

class FlipLayoutState extends State<FlipLayout> with SingleTickerProviderStateMixin {
  late AnimationController _animationControl;
  late List<Animation<double>> _unfoldAnimations;
  var childSize = 0;
  late List<Animation<double>>? _heightAnimations;

  void toggle() {
    if (_animationControl.status == AnimationStatus.completed) {
      _animationControl.reverse();
    } else {
      _animationControl.forward();
    }
  }

  @override
  void didUpdateWidget(covariant FlipLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    childSize = widget.children!.length;

    if (childSize <= 3) {
      _animationControl = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration));
    } else {
      _animationControl = AnimationController(
          vsync: this, duration: Duration(milliseconds: widget.duration * (childSize / 2).floor()));
    }

    Animation<double>? heightAnimation; //高度animation
    Animation<double> unfoldAnimation; //展开animation
    //折叠状态 0-1展开 0为折叠着  1为展开
    // _animationControl = 0;/// default
    if (!widget.foldState) {
      //展开状态 1为展开 下一个动画是 (1-0) 0为折叠，
      _animationControl.value = 1;
    }
    unfoldAnimation = _animationControl.drive(CurveTween(curve: Curves.easeInOut));
    heightAnimation = CurvedAnimation(
      parent: _animationControl,
      curve: const Cubic(0.75, 0.82, 0.08, 1.25),
    );
    if (childSize > 1) {
      double interval = 1.0 / (childSize);
      _unfoldAnimations = List.generate(childSize, (index) {
        /// (Tween(begin: 0, end: .5)); //首个
        /// Tween(begin: -.50,end: .5));//中间
        /// (Tween(begin: -.5, end: 0)); //最后
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
            .chain(CurveTween(curve: Interval(index * interval, (index + 1) * interval)))
            .animate(unfoldAnimation);
      });

      interval = 1.0 / (childSize - 1);
      _heightAnimations = List.generate(childSize - 1, (index) {
        CurveTween animatable;
        if (index == childSize - 2) {
          animatable = CurveTween(curve: IntervalOver1(index * interval, (index + 1) * interval));
          animatable.chain(CurveTween(curve: Curves.easeOutBack));
        } else {
          animatable = CurveTween(curve: IntervalSafe(index * interval, (index + 1) * interval));
        }
        return animatable.animate(heightAnimation!);
      });
    }

    _animationControl.addListener(() {
      setState(() {});
    });

    // _animationControl.repeat(reverse: false);
  }

  @override
  void dispose() {
    _animationControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var result = foldAbleLayout(context);
    if (widget.borderRadius != null) {
      result = ClipRRect(
        key: const ValueKey(0),
        borderRadius: widget.borderRadius != null ? widget.borderRadius! : BorderRadius.zero,
        child: result,
      );
    }
    return result;
  }

  Widget? _getFlip(int index) {
    Widget child = widget.children![index];
    var unfoldValue = _unfoldAnimations[index].value;
    if (index == 0) {
      return Flip(
        key: ValueKey(index),
        spinProgress: unfoldValue,

        /// 第一个item高度永远不变
        // heightProgress: _heightAnimations[index].value,
        child: child,
        back: widget.foldChild!,
      );
    }
    var heightValue = _heightAnimations![index - 1].value;
    if (heightValue <= 0) {
      return null;
    }
    if (index == childSize - 1) {
      return Flip(
        key: ValueKey(index),
        spinProgress: unfoldValue,
        heightProgress: heightValue,
        child: child,
      );
    }
    var background = widget.background ??
        Container(
          color: widget.backgroundColor,
        );
    return Flip(
      key: ValueKey(index),
      spinProgress: unfoldValue,
      heightProgress: heightValue,
      child: child,
      back: background,
    );
  }

  /// 折叠到展开  0-1
  /// 1, 围绕底部旋转 0-90     折叠状态 0
  /// 2，围绕顶部 90-0(-0>-90)，，围绕底部 0-90(要显示holder)  折叠状态 -90
  /// 3，围绕顶部 90-0     折叠状态 90 ---> 0 折叠到展开
  foldAbleLayout(BuildContext context) {
    List<Widget> flips = [];
    for (var index=0; index < childSize; index++) {
      var flip = _getFlip(index);
      if (flip == null) {
        break;
      } else {
        flips.add(flip);
      }
    }
    return Container(
      key: const ValueKey(0),
      decoration: widget.decoration,
      child: Column(
        key: const ValueKey(0),
        mainAxisSize: MainAxisSize.min,
        children: flips,
      ),
    );
  }
}

class Flip extends MultiChildRenderObjectWidget {
  final Widget child; //正常view
  final Widget? back; //旋转view
  late double spinProgress;
  double? heightProgress;

  Flip({
    Key? key,
    required this.child,
    required this.spinProgress,
    this.heightProgress,
    this.back,
  }) : super(key: key, children: back == null ? [child] : [child, back]);

  @override
  CarouselRenderObject createRenderObject(BuildContext context) {
    return CarouselRenderObject(
      spinProgress: spinProgress,
      heightProgress: heightProgress,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant CarouselRenderObject renderObject) {
    renderObject
      ..spinProgress = spinProgress
      ..highProgress = heightProgress;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('spinProgress', spinProgress));
    properties.add(DoubleProperty('heightProgress', heightProgress));
  }
}

class CarouselRenderObject extends RenderStack {
  Size _originalSize = Size.zero;

  late double _spinProgress;
  double? _heightProgress;

  double get spinProgress => _spinProgress;

  double? get highProgress => _heightProgress;
  Matrix4? _rotateTransform;

  set spinProgress(double value) {
    _spinProgress = value;
    markNeedsLayout();

    /// 类似 invalidate() 更新了属性要主动刷新下
  }

  set highProgress(double? value) {
    _heightProgress = value;
  }

  CarouselRenderObject({
    TextDirection? textDirection,
    double? heightProgress,
    required double spinProgress,
  }) : super(
          textDirection: textDirection,
          fit: StackFit.loose,
          clipBehavior: Clip.hardEdge,
        ) {
    _spinProgress = spinProgress;
    _heightProgress = _heightProgress;
  }

  @override
  void performLayout() {
    //只有最后一个位置 只要一个view 其他位置都要两个 头部 展开后要显示第一个 一个旋转的背面，一个展开后的首页  0--.5
    //中间的 上下旋转的背面，展开后显示的正面  -.5--.5
    //最后一个 只要展开显示正面  -.5-0
    // firstChild 为正常view; 不旋转 展开的时候以及之后要显示出来，
    // lastChild 旋转的view; 可能是背部可能是正面 最下面的位置为 正面

    if (spinProgress == -.5) {
      ///折叠起来之后就不需要占位置了
      firstChild!.layout(constraints, parentUsesSize: true);
      if (highProgress == null || highProgress == 0) {
        size = Size.zero;
      } else {
        //不可见的时候 先增加高度
        _originalSize = size = firstChild!.size;
        if (highProgress != null && highProgress! > 0) {
          size = Size(size.width, highProgress! * size.height);
        }
      }
      return;
    }

    // cos a * 斜边 = 夹角边长(邻边)
    firstChild!.layout(constraints, parentUsesSize: true);
    _originalSize = size = firstChild!.size;
    firstChild!.layout(BoxConstraints.tight(size), parentUsesSize: false);

    if (childCount == 2) {
      lastChild!.layout(BoxConstraints.tight(size), parentUsesSize: true);
    }
    if (highProgress != null && highProgress! > 0) {
      size = Size(size.width, highProgress! * size.height);
    } else {
      //没有高度变化的控制就自己变化高度
      if (spinProgress < 0) {
        size = Size(size.width,
            const Cubic(0.775, 0.685, 0.12, 1.05).transform(math.cos(spinProgress.abs() * pi)) * size.height);
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    /// 折叠到展开  0-1
    /// 1, 围绕底部旋转 0-90     折叠状态 0           0,0.5
    /// 2，围绕顶部 90-0(-90>0)，，围绕底部 0-90(要显示holder)  折叠状态 -90  -.5,.5
    /// 3，围绕顶部 90-0     折叠状态 90           -.5,0
    if (spinProgress == -.5) {
      ///折叠起来之后就不需要占位置了
      return;
    }
    var radians = spinProgress.abs() * pi;
    if (spinProgress > 0 && childCount == 2) {
      context.paintChild(firstChild!, offset);
    }
    if (spinProgress == .5) {
      return;
    }
    updateTransform(radians);
    context.pushTransform(
      needsCompositing,
      offset,
      _rotateTransform!,
      (context, offset) {
        context.paintChild(lastChild!, offset);
      },
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    if (firstChild!.hashCode == child.hashCode) {
      return;
    }
    //只有 lastChild做了旋转
    transform.multiply(_rotateTransform!);
  }

  /// 围绕底部旋转
  /// 1，向下移动到底部
  /// 2，反向旋转即可(比如要围绕底部旋转30，那么应该旋转 180-30)
  bool get alignmentBottom {
    return spinProgress > 0;
  }

  void updateTransform(double radians) {
    AlignmentDirectional alignmentDirectional = AlignmentDirectional.topCenter;

    /// https://medium.com/flutter/perspective-on-flutter-6f832f4d912e
    /// https://medium.com/flutter-community/make-3d-flip-animation-in-flutter-16c006bb3798
    /// It points out that changing value at row 3 and column 2 of
    /// Matrix4 will change its perspective and bring up 3-D effect into our transformation
    var _transform = Matrix4.identity()..setEntry(3, 2, 0.001); // perspective

    if (alignmentBottom) {
      /// 围绕底部旋转
      alignmentDirectional = AlignmentDirectional.bottomCenter;
      _transform.rotateX(radians);
    } else {
      /// 围绕顶部旋转
      alignmentDirectional = AlignmentDirectional.topCenter;
      _transform.rotateX(-radians);
    }

    final Alignment resolvedAlignment = alignmentDirectional.resolve(textDirection);
    final Matrix4 result = Matrix4.identity();
    Offset? translation;
    translation = resolvedAlignment.alongSize(_originalSize);

    /// 先移动到底部
    result.translate(translation.dx, translation.dy);

    result.multiply(_transform);

    /// 执行旋转
    result.translate(-translation.dx, -translation.dy);

    ///再移回去
    _rotateTransform = result;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (childCount == 2 && lastChild!.hasSize) {
      bool hited = result.addWithPaintTransform(
        transform: _rotateTransform ?? Matrix4.identity(),
        position: position,
        hitTest: (BoxHitTestResult result, Offset? position) {
          return lastChild!.hitTest(result, position: position!);
        },
      );
      if (!hited) {
        hited = firstChild!.hitTest(result, position: position);
      }
      return hited;
    }
    return firstChild!.hitTest(result, position: position);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (size.contains(position)) {
      if (hitTestChildren(result, position: position)) {
        result.add(BoxHitTestEntry(this, position));
        return true;
      }
    }
    return false;
  }
}

class IntervalOver1 extends Interval {
  const IntervalOver1(double begin, double end) : super(begin, end);

  @override
  double transform(double t) {
    t = ((t - begin) / (end - begin)).clamp(0.0, 1.1);
    if (t == 0.0 || t == 1.0) return t;
    return t;
  }
}

class IntervalSafe extends Interval {
  const IntervalSafe(double begin, double end) : super(begin, end);

  @override
  double transform(double t) {
    t = ((t - begin) / (end - begin)).clamp(0.0, 1);
    if (t == 0.0 || t == 1.0) return t;
    return t;
  }
}
