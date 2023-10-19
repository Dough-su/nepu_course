import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muse_nepu_course/util/global.dart';
const dragSnapDuration = Duration(milliseconds: 300);
const draggableMinWidth = 60.0;

class QingjiaButton extends StatefulWidget {
  const QingjiaButton({
    super.key,
    this.enabled = false,
    this.width = 100,
    required this.qsrq,
    required this.qssj,
    required this.jssj,
    required this.jsrq,
    required this.qjsy,
    required this.qjlx,
    required this.chaosong,
  });

  final bool enabled;
  final double width;
  final String qsrq;
  final String qssj;
  final String jssj;
  final String jsrq;

  //请假事由
  final String qjsy;
  //请假类型
  final String qjlx;
  //抄送人
  final  chaosong;


  @override
  State<QingjiaButton> createState() => _QingjiaButtonState();
}

class _QingjiaButtonState extends State<QingjiaButton>
    with TickerProviderStateMixin {
  late final AnimationController loadingAnimationController;
  //错误原因
  String errorText = '';

  double dragOffset = 0;
  Duration dragDuration = Duration.zero;
  static const draggableMinWidth = 60.0;

  bool get canDrag => (status.isIdle || status.isPending) && !status.isSuccess;

  PaymentStatus status = PaymentStatus.idle;

  double get draggableMaxWidth => widget.width - 4 * 2;

  double get maxDraggableDistance => draggableMaxWidth - draggableMinWidth;

  double get dragThreshold => maxDraggableDistance * 0.8;


  void _handleHorizontalDragStart(DragStartDetails details) {
    if (dragDuration > Duration.zero) {
      dragDuration = Duration.zero;
    }
  }

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    if (canDrag) {
      setState(() {
        dragOffset =
            (dragOffset + details.delta.dx).clamp(0, maxDraggableDistance);
        if (!status.isPending) {
          status = PaymentStatus.pending;
        }
      });
    }
  }

  Future<void> _handleHorizontalDragEnd(DragEndDetails details) async {
    if (!status.isSuccess) {
      dragDuration = dragSnapDuration;
      if (dragOffset <= dragThreshold) {
        setState(() {
          dragOffset = 0;
          status = PaymentStatus.idle;
        });
      } else {
        setState(() {
          dragOffset = maxDraggableDistance;
          status = PaymentStatus.loading;
        });
        loadingAnimationController.repeat();
        var request = http.MultipartRequest('POST', Uri.parse('https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/qingjia'));
        print(widget.chaosong);
        request.fields.addAll({
          'uname': Global.jwc_xuehao,
          'pd_mm': Global.xgc_password,
          'qjlx': widget.qjlx,
          'csr': widget.chaosong.toString(),
          'kssj': widget.qsrq + ' ' + widget.qssj,
          'jssj': widget.jsrq + ' ' + widget.jssj,
          'qjsy': widget.qjsy,
          'lxr': Global.contact,
          'lxrdh': Global.contact_phone,
        });
        print(request.fields);
        Global.save_contact();

        final stream = await request.send();
        final res = await http.Response.fromStream(stream);
        // 添加一个判断条件，如果请求成功，则显示请假成功，否则显示请假失败
        if (res.statusCode == 200) {
          print(res.body);
          //转为json格式
          Map<String, dynamic> data = jsonDecode(res.body);
          if (data['error'] == true) {
            setState(() {
              errorText = data['msg'];
              status = PaymentStatus.fail;
            });
          } else {
            setState(() {
              Global.save_xgc_password();
              status = PaymentStatus.success;
            });
          }

        }else
        {
          setState(() {
            status = PaymentStatus.fail;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:  Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Color(0xFF1C1B1F),
      ),
      height: 60,
      padding: const EdgeInsets.all(4),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(left: draggableMinWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '滑动请假',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  _AnimatedArrows(enabled: widget.enabled),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: dragDuration,
            curve: Curves.easeOut,
            top: 0,
            left: 0,
            bottom: 0,
            width: draggableMinWidth + dragOffset,
            child: GestureDetector(
              onHorizontalDragUpdate: _handleHorizontalDragUpdate,
              onHorizontalDragStart: _handleHorizontalDragStart,
              onHorizontalDragEnd: _handleHorizontalDragEnd,
              child: AnimatedBuilder(
                animation: loadingAnimationController,
                builder: (context, child) {
                  return _buildDollarIcon(
                    context,
                    dragOffset: dragOffset,
                    loadingAnimationValue: loadingAnimationController.value,
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: dragOffset >= dragThreshold && status.isPending ? 1 : 0,
              curve: Curves.easeOut,
              child: const Center(
                child: Text(
                  '释放来确认请假',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          if(status.isSuccess)
          Positioned.fill(
            child: AnimatedSlide(
              onEnd: () async {
              },
              duration: const Duration(milliseconds: 1000),
              offset: Offset(0, status.isSuccess ? 0 : 1),
              curve: Curves.easeOut,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check),
                  SizedBox(width: 10),
                  Center(
                    child: Text(
                      '请假成功',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                ],
              ),
            ),
          ),
          if(status.isFail)
          Positioned.fill(
            child: AnimatedSlide(
              onEnd: () {},
              duration: const Duration(milliseconds: 1000),
              offset: Offset(0, status.isFail ? 0 : 1),
              curve: Curves.easeOut,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Center(
                    child: Text(
                      errorText,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDollarIcon(
      BuildContext context, {
        double dragOffset = 0,
        double loadingAnimationValue = 0,
      }) {
    final yRotation = status.isPending
        ? 4 * pi * (dragOffset / maxDraggableDistance)
        : status.isLoading
        ? 2 * pi * loadingAnimationValue
        : 0.0;

    Widget child = SizedBox(
      width: 60,
      child: Center(
        child: Icon(
          Icons.beach_access_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
    );

    // y rotation - happens while loading OR dragging
    child = Transform(
      transform: Matrix4.identity()..rotateY(yRotation),
      alignment: Alignment.center,
      child: child,
    );

    // Slide animation - sliding the Dollar up on success
    child = AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: Offset(0, status.isSuccess ? -1 : 0),
      curve: Curves.easeOut,
      child: child,
    );

    // Animate alignment & color
    // Alignment is center as long as the status is not pending, which means
    // the user is dragging and the dollar should follow the right edge of
    // the dragged area
    child = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      alignment: !status.isPending ? Alignment.center : Alignment.centerRight,
      decoration: BoxDecoration(
        color: status.isSuccess ? Colors.green :Global.home_currentcolor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );

    return child;
  }
}

class _AnimatedArrows extends StatefulWidget {
  const _AnimatedArrows({
    this.enabled = false,
  });

  final bool enabled;

  @override
  State<_AnimatedArrows> createState() => __AnimatedArrowsState();
}

class __AnimatedArrowsState extends State<_AnimatedArrows>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const offset = 10.0;
    const count = 5;

    return SizedBox(
      width: (count + 1) * offset,
      child: Stack(
        children: List.generate(
          count,
              (index) => Positioned(
            left: offset * index,
            bottom: 0,
            top: 0,
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                  (index / count) * 0.5,
                  1,
                  curve: Curves.easeInOut,
                ),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum PaymentStatus {
  /// User has not interacted with the button
  idle,

  /// User has started dragging
  pending,

  /// User has released the button after reaching the end of the draggable area
  loading,

  /// Payment was successful
  success,

  fail; // 请假失败
  // 添加相应的判断方法
  bool get isFail => this == fail;

  bool get isSuccess => this == success;

  bool get isLoading => this == loading;

  bool get isPending => this == pending;

  bool get isIdle => this == idle;
}
