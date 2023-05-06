import 'dart:math';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/models/challenge_participation.dart';
import 'package:weekly_challenge/models/participant.dart';
import 'package:weekly_challenge/utils.dart';

class FriendsComparison extends StatefulWidget {
  const FriendsComparison({super.key});

  @override
  State<FriendsComparison> createState() => _FriendsComparisonState();
}

class _FriendsComparisonState extends State<FriendsComparison> {
  @override
  Widget build(BuildContext context) {
    Map<Participant, List<ChallengeParticipation>> participations = context
        .watch<FirestoreHandler>()
        .getChallengeParticipationsForWeek(weeksSinceNow: 0);

    List<LineChartBarData> lineBarsData = getLineBarsData(participations);

    LineChartData challengeDoneData = LineChartData(
      lineTouchData: getLineTouchData(participations),
      gridData: gridData,
      titlesData: titlesData1,
      borderData: borderData,
      lineBarsData: lineBarsData,
      minX: 0,
      maxX: 7,
      maxY: 7,
      minY: 0,
    );

    return LineChart(challengeDoneData);
  }

  List<LineChartBarData> getLineBarsData(
      Map<Participant, List<ChallengeParticipation>> participations) {
    List<LineChartBarData> lineBarsData = [];
    participations.forEach((key, value) {
      int index = participations.keys.toList().indexOf(key);
      lineBarsData.add(getBarDataByParticipations(key, value, index));
    });
    return lineBarsData;
  }

  LineChartBarData getBarDataByParticipations(Participant participant,
      List<ChallengeParticipation> participations, int index) {
    List<FlSpot> spots = [const FlSpot(0, 0)];
    double currentLevel = 0;
    participations.sort((a, b) => a.dateCompleted.compareTo(b.dateCompleted));
    for (int i = 1; i < 8; i++) {
      //levelForDay should return the current value and add 1 to currentLevel if there is a participation on that weekday
      ChallengeParticipation? participationForDay = participations
          .cast()
          .firstWhere((element) => element.dateCompleted.weekday == i,
              orElse: () => null);
      if (participationForDay != null) {
        currentLevel++;
      }
      spots.add(FlColorSpot(i.toDouble(), currentLevel,
          color: colorPalette[index],
          participant: participant,
          currentLevel: currentLevel.toInt()));
    }
    return LineChartBarData(
      isCurved: true,
      curveSmoothness: 0,
      color: colorPalette[index],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: spots,
    );
  }

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(),
        ),
      );

  LineTouchData getLineTouchData(participations) {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            //display participants names
            return touchedSpots.map((LineBarSpot touchedSpot) {
              FlSpot flSpot = touchedSpot.bar.spots[touchedSpot.spotIndex];
              if (flSpot is FlColorSpot) {
                FlColorSpot spot = flSpot;
                if (spot.x == 0 || spot.y == 0) {
                  return null;
                }
                return LineTooltipItem(
                  "${spot.participant.name}: ${spot.y.toInt()}",
                  TextStyle(color: spot.color),
                );
              } else {
                return null;
              }
            }).toList();
          },
          tooltipBgColor: Theme.of(context).colorScheme.primary),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = Theme.of(context).textTheme.titleSmall!;
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('START', style: style);
        break;
      case 1:
        text = Text('MON', style: style);
        break;
      case 2:
        text = Text('DIE', style: style);
        break;
      case 3:
        text = Text('MIT', style: style);
        break;
      case 4:
        text = Text('DON', style: style);
        break;
      case 5:
        text = Text('FRE', style: style);
        break;
      case 6:
        text = Text('SAM', style: style);
        break;
      case 7:
        text = Text('SON', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).colorScheme.primaryContainer, width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );
}

class FlColorSpot extends FlSpot {
  final Color color;
  final Participant participant;
  final int currentLevel;

  FlColorSpot(double x, double y,
      {this.color = Colors.black,
      required this.participant,
      this.currentLevel = 0})
      : super(x, y);
}
