import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/response.dart';
import 'package:kalahok_app/helpers/functions.dart';

/// CHECKED
class LocalSoundRecorderService {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised = false;
  bool _isPlaybackReady = false;
  late Questionnaire _questionnaire;

  bool get isRecordingAvailable => _isPlaybackReady && !isRecording;
  bool get isRecording => _audioRecorder!.isRecording;

  Future init({ required Questionnaire questionnaire }) async {
    _audioRecorder = FlutterSoundRecorder();
    _questionnaire = questionnaire;

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
    String appDirFolderPath = await Functions.getRecordingPath();
    String path = join(
      appDirFolderPath,
      'recording-$timestamp-question#${_questionnaire.id}-survey#${_questionnaire.survey.id}@PENDING.aac',
    );

    if (_questionnaire.response == null) {
      _questionnaire.response = Response(
        surveyQuestion: _questionnaire.question,
        questionFieldTexts: List.generate(1, (i) => _questionnaire.question),
        responses: [],
        otherResponse: '',
        file: path,
      );
    } else {
      _questionnaire.response?.file = path;
    }
    _questionnaire.hasRecording = true;
    _questionnaire.hasInput = false;

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
