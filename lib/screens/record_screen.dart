import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/services/sound_player_service.dart';
import 'package:kalahok_app/services/sound_recorder_service.dart';
import 'package:kalahok_app/widgets/audio_button_widget.dart';
import 'package:kalahok_app/widgets/timer_widget.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final timerController = TimerController();
  final recorder = SoundRecorderService();
  final player = SoundPlayerService();

  @override
  void initState() {
    super.initState();

    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    player.dispose();
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
            _buildPlayer(),
            const SizedBox(height: 16),
            _buildStart(),
            const SizedBox(height: 20),
            _buildPlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlay() {
    bool isPlaying = player.isPlaying;
    IconData icon = isPlaying ? Icons.stop : Icons.play_arrow;
    String text = isPlaying ? 'Stop Playing' : 'Play Recording';
    Color backgroundC = isPlaying ? AppColor.darkError : AppColor.primary;

    return AudioButtonWidget(
      text: text,
      color: AppColor.subPrimary,
      backgroundColor: backgroundC,
      icon: icon,
      onClicked: () async {
        if (!recorder.isRecordingAvailable) return;

        await player.togglePlaying(whenFinished: () => setState(() {}));
        setState(() {});
      },
    );
  }

  Widget _buildStart() {
    bool isRecording = recorder.isRecording;
    IconData icon = isRecording ? Icons.stop : Icons.mic;
    String text = isRecording ? 'Stop' : 'Record';
    Color backgroundC = isRecording ? AppColor.darkError : AppColor.primary;

    return AudioButtonWidget(
      text: text,
      color: AppColor.subPrimary,
      backgroundColor: backgroundC,
      icon: icon,
      onClicked: () async {
        if (player.isPlaying) return;

        await recorder.toggleRecording();
        final isRecording = recorder.isRecording;
        setState(() {});

        if (isRecording) {
          timerController.startTimer();
        } else {
          timerController.stopTimer();
        }
      },
    );
  }

  Widget _buildPlayer() {
    String text = recorder.isRecording ? 'Now Recording' : 'Press Record';
    bool animate = player.isPlaying || recorder.isRecording;

    return AvatarGlow(
      endRadius: 140,
      animate: animate,
      repeatPauseDuration: const Duration(seconds: 1),
      glowColor: AppColor.subSecondary,
      child: CircleAvatar(
        radius: 105,
        backgroundColor: AppColor.warning,
        child: CircleAvatar(
          radius: 92,
          backgroundColor: AppColor.primary,
          child: player.isPlaying
              ? const Icon(Icons.audiotrack_outlined, size: 120)
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mic, size: 32),
                  TimerWidget(controller: timerController),
                  const SizedBox(height: 8),
                  Text(text),
                ],
              ),
        ),
      ),
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
