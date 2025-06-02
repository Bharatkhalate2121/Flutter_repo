import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:news_app/context/context_class.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  dynamic globalState;

  AnimationController? _controller;
  Timer? _timer;

  Duration totalDuration = const Duration(minutes: 1);
  late int remainingSeconds;
  bool isExpired = false;

  @override
  void initState() {
    super.initState();
    globalState = Provider.of<ContextClass>(context, listen: false);
    initializeTimer();
  }

  Future<void> initializeTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final int now = DateTime.now().millisecondsSinceEpoch;
    final int? startTime =
        /*DateTime.now().millisecondsSinceEpoch; */ prefs.getInt('timer');

    if (startTime != null) {
      final elapsed = Duration(milliseconds: now - startTime);
      final remaining = totalDuration - elapsed;

      if (remaining.isNegative) {
        // Timer already expired
        setState(() {
          isExpired = true;
          remainingSeconds = 0;
        });
        // print('hello mfs');
        // if (!globalState.showDialog) globalState.showDialog = true;

        return;
      } else {
        totalDuration = remaining;
        remainingSeconds = remaining.inSeconds;
      }
    } else {
      // First-time start
      await prefs.setInt('timer', now);
      remainingSeconds = totalDuration.inSeconds;
    }

    _controller = AnimationController(vsync: this, duration: totalDuration)
      ..forward(from: 0.0);

    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds <= 0) {
        _timer?.cancel();
        setState(() {
          isExpired = true;
        });
        // print('hello mfs');
        // if (!globalState.showDialog) globalState.showDialog = true;
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  String get timerText {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null && !isExpired) return CircularProgressIndicator();
    if (isExpired) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Expired",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'login',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(
                          context,
                          '/users',
                          arguments: {'loginPage': true},
                        );
                      },
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text: ' to enjoy uninterrupted service',
                    style: TextStyle(
                      color:
                          Provider.of<ContextClass>(
                            context,
                            listen: false,
                          ).theme
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // SizedBox(height: 1,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width * 0.875),
            IconButton(
              onPressed: () {
                Provider.of<ContextClass>(context, listen: false).showDialog =
                    false;
                Navigator.pop(context);
              },
              icon: Icon(Icons.close),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.directional(
                      topStart: Radius.circular(0),
                      topEnd: Radius.circular(30),
                      bottomStart: Radius.circular(0),
                      bottomEnd: Radius.circular(0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        Text('Your access ends in'),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.3,
          child: AnimatedBuilder(
            animation: _controller!,
            builder: (context, child) => Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: _controller?.value,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade300,

                    color: (_controller!.value > 0.6)
                        ? Colors.green
                        : (_controller!.value > 0.4)
                        ? Colors.yellow
                        : Colors.green,
                  ),
                ),
                Text(
                  timerText,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'login',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(
                      context,
                      '/users',
                      arguments: {'loginPage': true},
                    );
                  },
                style: TextStyle(color: Colors.blue),
              ),
              TextSpan(
                text: ' to enjoy uninterrupted service',
                style: TextStyle(
                  color: Provider.of<ContextClass>(context, listen: false).theme
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
