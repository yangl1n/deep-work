import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/countdown.dart';
import 'alarm_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final countdown = context.read<CountdownModel>();
    countdown.onAlarmTriggered = () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AlarmScreen()),
      );
    };
  }
  @override
  Widget build(BuildContext context) {
    final countdown = context.watch<CountdownModel>();

    double progress =
        (countdown.timeLeft > 0 || countdown.timeLeft != countdown.totalTime)
            ? countdown.timeLeft / countdown.totalTime
            : 0;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          _getCircularProgress(progress: progress),
          GestureDetector(
            onTap: countdown.isRunning ? countdown.stop : countdown.start,
            child: countdown.isRunning
                ? _getRunScene(countdown)
                : _getStopScene(context, countdown),
          ),
        ],
      ),
    );
  }

  Widget _getCircularProgress({required double progress}) {
    return SizedBox(
      width: 250,
      height: 250,
      child: CircularProgressIndicator(
        value: 1 - progress,
        strokeWidth: 10,
        color: Colors.blue,
        backgroundColor: Colors.grey[300],
      ),
    );
  }

  Widget _getStopScene(BuildContext context, CountdownModel countdown) {
    return Container(
      width: 240,
      height: 240,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Start',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _editCountdown(context, countdown),
            child: Text(
              _formatTime(countdown.totalTime),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: Colors.black,
                decorationStyle: TextDecorationStyle.double,
                decorationThickness: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getRunScene(CountdownModel countdown) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Finish',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _formatTime(countdown.timeLeft),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<void> _editCountdown(
      BuildContext context, CountdownModel countdown) async {
    int hours = countdown.totalTime ~/ 3600;
    int minutes = (countdown.totalTime % 3600) ~/ 60;

    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) {
        int selectedHours = hours;
        int selectedMinutes = minutes;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Set Countdown'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Hours: $selectedHours'),
                  Slider(
                    value: selectedHours.toDouble(),
                    min: 0,
                    max: 23,
                    divisions: 23,
                    label: '$selectedHours',
                    onChanged: (val) {
                      setDialogState(() => selectedHours = val.toInt());
                    },
                  ),
                  Text('Minutes: $selectedMinutes'),
                  Slider(
                    value: selectedMinutes.toDouble(),
                    min: 0,
                    max: 59,
                    divisions: 59,
                    label: '$selectedMinutes',
                    onChanged: (val) {
                      setDialogState(() => selectedMinutes = val.toInt());
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, {
                    'hours': selectedHours,
                    'minutes': selectedMinutes,
                  }),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      int newTotal = result['hours']! * 3600 + result['minutes']! * 60;
      countdown.setTime(newTotal);
    }
  }

  String _formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int sec = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}
