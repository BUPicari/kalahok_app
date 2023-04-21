import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:intl/intl.dart';
import 'package:kalahok_app/data/models/answer_model.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/helpers/utils.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorderService {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised = false;
  bool _isPlaybackReady = false;
  late Questions _question;

  bool get isRecordingAvailable => _isPlaybackReady && !isRecording;
  bool get isRecording => _audioRecorder!.isRecording;

  Future init({required Questions question}) async {
    _audioRecorder = FlutterSoundRecorder();
    _question = question;

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
  }

  Future _record() async {
    if (!_isRecorderInitialised) return;

    String timestamp = DateFormat.yMd().format(DateTime.now()).toString().replaceAll('/', '_');
    String appDirFolderPath = await Utils.getRecordingPath();
    String path = join(
      appDirFolderPath,
      'recording-$timestamp-question#${_question.id}-survey#${_question.surveyId}@PENDING.aac'
    );

    /// set Question response answer
    _question.answer = Answer(
      surveyQuestion: _question.question,
      questionFieldTexts: List.generate(1, (i) => _question.question),
      answers: List.generate(1, (i) => path),
      otherAnswer: ''
    );

    /// todo: get the audio using the path when sending to api

    await _audioRecorder!.startRecorder(toFile: path);
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
