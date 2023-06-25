import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/services/sound_recorder_service.dart';
import 'package:kalahok_app/widgets/audio_button_widget.dart';

class AudioWidget extends StatefulWidget {
  const AudioWidget({Key? key}) : super(key: key);

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  final recorder = SoundRecorderService();
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;

  void resetTimer() => setState(() => seconds = maxSeconds);

  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        stopTimer(reset: false);
      }
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }

    setState(() => timer?.cancel());
  }

  @override
  void initState() {
    super.initState();

    // recorder.init();
  }

  @override
  void dispose() {
    recorder.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimer(),
            const SizedBox(height: 80),
            _buildButtons(),
            // _buildRecord(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    bool isRunning = timer == null ? false : timer!.isActive;
    bool isComplete = seconds == maxSeconds || seconds == 0;

    return isRunning || !isComplete
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AudioButtonWidget(
                text: isRunning ? 'Pause' : 'Resume',
                icon: isRunning ? Icons.stop : Icons.play_arrow,
                color: AppColor.subPrimary,
                backgroundColor: AppColor.primary,
                onClicked: () {
                  if (isRunning) {
                    stopTimer(reset: false);
                  } else {
                    startTimer(reset: false);
                  }
                },
              ),
              const SizedBox(width: 12),
              AudioButtonWidget(
                text: 'Cancel',
                icon: Icons.cancel,
                color: AppColor.subPrimary,
                backgroundColor: AppColor.primary,
                onClicked: stopTimer,
              ),
            ],
          )
        : AudioButtonWidget(
            text: 'Record',
            icon: Icons.mic,
            color: AppColor.subPrimary,
            backgroundColor: AppColor.primary,
            onClicked: startTimer,
          );
  }

  Widget _buildTimer() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: seconds / maxSeconds,
            valueColor: AlwaysStoppedAnimation(AppColor.warning),
            strokeWidth: 15,
            backgroundColor: AppColor.primary,
          ),
          Center(
            child: _buildTime(),
          ),
        ],
      ),
    );
  }

  Widget _buildTime() {
    if (seconds == 0) {
      return Icon(
        Icons.done,
        color: AppColor.warning,
        size: 112,
      );
    }

    return Text(
      '$seconds',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColor.primary,
        fontSize: 80,
      ),
    );
  }

  Widget _buildRecord() {
    bool isRecording = recorder.isRecording;
    IconData icon = isRecording ? Icons.stop : Icons.mic;
    String text = isRecording ? 'STOP' : 'RECORD';
    Color backgroundC = isRecording ? AppColor.darkError : AppColor.primary;

    return AudioButtonWidget(
        text: text,
        color: AppColor.subPrimary,
        backgroundColor: backgroundC,
        icon: icon,
        onClicked: () async {
          final isRecording = await recorder.toggleRecording();
          setState(() {});
        },
    );
  }

  PreferredSizeWidget _buildAppBar(context) {
    return AppBar(
      title: const Text('Record Answer'),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColor.linearGradient,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
      ),
      leading: const BackButton(),
    );
  }
}
