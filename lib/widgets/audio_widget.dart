import 'package:flutter/material.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/services/sound_recorder_service.dart';

class AudioWidget extends StatefulWidget {
  const AudioWidget({Key? key}) : super(key: key);

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  final recorder = SoundRecorderService();

  @override
  void initState() {
    super.initState();

    recorder.init();
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
      backgroundColor: AppColor.primary,
      body: Center(
        child: _buildAudioRecordAndPlay(),
      ),
    );
  }

  Widget _buildAudioRecordAndPlay() {
    bool isRecording = recorder.isRecording;
    IconData icon = isRecording ? Icons.stop : Icons.mic;
    String text = isRecording ? 'STOP' : 'RECORD';
    Color backgroundC = isRecording ? AppColor.darkError : AppColor.subPrimary;
    Color foregroundC = isRecording ? AppColor.subPrimary : AppColor.subSecondary;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(175, 50),
        backgroundColor: backgroundC,
        foregroundColor: foregroundC,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(icon),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
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
