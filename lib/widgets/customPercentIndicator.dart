import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomCircularPercentageIndicator extends StatelessWidget {
  final int target;
  final int current;
  final double percent;
  final String targetName;
  final Color normalColor;
  final Color exceedColor;
  CustomCircularPercentageIndicator(
      {required this.targetName,
      required this.target,
      required this.current,
      required this.normalColor,
      required this.exceedColor})
      : percent = current / target;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircularPercentIndicator(
          progressColor: percent > 1 ? exceedColor : normalColor,
          radius: 170,
          lineWidth: 15,
          animation: true,
          percent: percent > 1 ? 1 : percent,
          // TODO: Add global style provider
          header: Text(targetName, style: null),
          center: Text("%${(percent * 100).toInt()}"),
        ),
        Text("Alınan: ${current}"),
        Text("Hedef: ${target}"),
      ],
    );
  }
}
