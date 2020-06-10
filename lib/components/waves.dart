import 'dart:math';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
class AnimatedWave extends StatelessWidget {
  final Color barColor;
  AnimatedWave({this.barColor});
  int randomInt(int min, int max) => min + Random().nextInt(max - min);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 3,
              width: 120,
              decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(30)),
            ),
            Container(
              height: 3,
              width: 3,
              decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(30)),
            ),
            for (var i = 0; i < 10; i++)
              TimerBuilder.periodic(
                Duration(milliseconds: 300),
                builder: (context) => AnimatedContainer(
                  width: 3,
                  height: i < 3
                      ? randomInt(10, 40).toDouble()
                      : (i < 7
                          ? randomInt(20, 80).toDouble()
                          : randomInt(10, 40).toDouble()),
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            Container(
              height: 3,
              width: 3,
              decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(30)),
            ),
            Container(
              height: 3,
              width: 120,
              decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(30)),
            ),
          ],
        ),
      ),
    );
  }
}
