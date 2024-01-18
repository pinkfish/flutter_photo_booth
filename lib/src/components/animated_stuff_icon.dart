import 'dart:async';

import 'package:flutter/cupertino.dart';

class AnimatedStuffIcon extends StatefulWidget {
  final double size;
  final List<IconData> icons;
  final Color? color;

  const AnimatedStuffIcon({super.key, required this.size, required this.icons, this.color});

  @override
  State<StatefulWidget> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<AnimatedStuffIcon> {
  late Timer _timer;
  int _iconIdx = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (t) => setState(() {
        _iconIdx = (_iconIdx + 1) % widget.icons.length;
        print('idx $_iconIdx');
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Icon(
        widget.icons[_iconIdx],
        color: widget.color,
        key: Key('icon$_iconIdx'),
        size: widget.size,
      ),
    );
  }
}
