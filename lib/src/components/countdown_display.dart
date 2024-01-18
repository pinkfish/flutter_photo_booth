import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountdownDisplay extends AnimatedWidget {
  const CountdownDisplay({super.key, required Animation<double> animation})
      : super(listenable: animation);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: _progress.value.toInt());

    String timerText =
        clockTimer.inSeconds.remainder(60).toString().padLeft(1, '0');

    return LayoutBuilder(
      builder: (context, layout) => SizedBox(
        height: 300,
        width: 300,
        child: DecoratedBox(
          decoration:  ShapeDecoration(
            color: Colors.grey.withOpacity(0.5),
            shape: const CircleBorder(),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              key: Key(timerText),
              timerText,
              style: const TextStyle(
                fontSize: 200,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
