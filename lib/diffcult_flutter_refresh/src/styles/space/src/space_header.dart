part of easy_refresh_space;

class SpaceHeader extends Header {
  final Key? key;

  const SpaceHeader({
    this.key,
    bool clamping = false,
    double triggerOffset = _kDefaultSpaceTriggerOffset,
    IndicatorPosition position = IndicatorPosition.above,
    Duration processedDuration = Duration.zero,
    SpringDescription? spring,
    SpringBuilder? readySpringBuilder,
    bool springRebound = false,
    FrictionFactor? frictionFactor,
    double? infiniteOffset,
    bool? hitOver,
    bool? infiniteHitOver,
    bool hapticFeedback = false,
  }) : super(
          triggerOffset: triggerOffset,
          clamping: clamping,
          processedDuration: processedDuration,
          spring: spring,
          readySpringBuilder: readySpringBuilder,
          springRebound: springRebound,
          frictionFactor: frictionFactor,
          safeArea: false,
          infiniteOffset: infiniteOffset,
          hitOver: hitOver,
          infiniteHitOver: infiniteHitOver,
          position: position,
          hapticFeedback: hapticFeedback,
        );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    assert(state.axis == Axis.vertical,
        'SpaceHeader does not support horizontal scrolling.');
    return _SpaceIndicator(
      key: key,
      state: state,
      reverse: state.reverse,
    );
  }
}
