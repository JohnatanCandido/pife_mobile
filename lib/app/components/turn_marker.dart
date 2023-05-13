import 'package:flutter/material.dart';
import 'package:pife_mobile/app/controllers/turn_marker_controller.dart';

class TurnMarker extends StatefulWidget {
  const TurnMarker({super.key});

  @override
  State<TurnMarker> createState() => _TurnMarkerState();
}

class _TurnMarkerState extends State<TurnMarker> with TickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  @override
  void initState() {
    super.initState();
    TurnMarkerController.instance.addListener(_setState);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    TurnMarkerController.instance.removeListener(_setState);
    _controller.dispose();
    super.dispose();
  }

  void _setState() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var properties = TurnMarkerController.instance.getPosition();
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      top: properties['top'],
      left: properties['left'],
      bottom: properties['bottom'],
      child: RotationTransition(
        turns: _animation,
        child: const Icon(
          Icons.motion_photos_on_outlined,
          size: 20,
        ),
      ),
    );
  }
}