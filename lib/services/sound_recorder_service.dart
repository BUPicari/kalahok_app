// import 'dart:io';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const pathToSaveAudio = 'audio_example.aac';

class SoundRecorderService {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised = false;
  bool _isPlaybackReady = false;
  // String _path = '';

  bool get isRecordingAvailable => _isPlaybackReady && !isRecording;
  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone Permission');
    }

    await _audioRecorder!.openAudioSession();
    _isRecorderInitialised = true;
  }

  void dispose() async {
    if (!_isRecorderInitialised) return;

    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialised = false;

    // File recording = File('$_path/recording.mp3');
    // if (await recording.exists()) {
    //   String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    //   await recording.rename('$_path/recording_$timestamp.mp3');
    // }
  }

  Future _record() async {
    if (!_isRecorderInitialised) return;

    // Directory appDirectory = await getApplicationDocumentsDirectory();
    // _path = '${appDirectory.path}/recordings';
    // await Directory(_path).create(recursive: true);

    await _audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }

  Future _stop() async {
    if (!_isRecorderInitialised) return;

    await _audioRecorder!.stopRecorder();
    _isPlaybackReady = true;
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}
