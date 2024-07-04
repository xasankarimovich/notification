// import 'package:flutter/material.dart';
// import 'package:percent_indicator/percent_indicator.dart';

// class PomodoroScreen extends StatefulWidget {
//   const PomodoroScreen({super.key});

//   @override
//   State<PomodoroScreen> createState() => _PomodoroScreenState();
// }

// class _PomodoroScreenState extends State<PomodoroScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff1f1b2e),
//       body: SafeArea(
//         child: Center(
//           child: CircularPercentIndicator(
//             radius: 120,
//             percent: 0.3,
//             animation: true,
//             restartAnimation: true,
//             progressColor: const Color(0xff5550fe),
//             center: const Text(
//               "19:49",
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  double percent = 0.0;
  int seconds = 0;
  int maxSeconds = 20 * 60; // 20 minutes in seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (seconds >= maxSeconds) {
          timer.cancel();
        } else {
          seconds++;
          percent = seconds / maxSeconds;
        }
      });
    });
  }

  String timerText() {
    int minutes = (maxSeconds - seconds) ~/ 60;
    int remainingSeconds = (maxSeconds - seconds) % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1f1b2e),
      body: SafeArea(
        child: Center(
          child: CircularPercentIndicator(
            radius: 120,
            percent: percent,
            animation: true,
            restartAnimation: true,
            progressColor: const Color(0xff5550fe),
            center: Text(
              timerText(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}