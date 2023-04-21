import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:intl/intl.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/helpers/utils.dart';
import 'package:path/path.dart';

class SoundPlayerService {
  FlutterSoundPlayer? _audioPlayer;
  late Questions _question;

  bool get isPlaying => _audioPlayer!.isPlaying;

  Future init({required Questions question}) async {
    _audioPlayer = FlutterSoundPlayer();
    _question = question;

    await _audioPlayer!.openAudioSession();
  }

  void dispose() {
    _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
  }

  Future _play(VoidCallback whenFinished) async {
    String timestamp = DateFormat.yMd().format(DateTime.now()).toString().replaceAll('/', '_');
    String appDirFolderPath = await Utils.getRecordingPath();
    String path = join(
      appDirFolderPath,
      'recording-$timestamp-question#${_question.id}-survey#${_question.surveyId}@PENDING.aac'
    );

    await _audioPlayer!.startPlayer(
      fromURI: path,
      // codec: Codec.mp3,
      whenFinished: whenFinished,
    );
  }

  Future _stop() async {
    await _audioPlayer!.stopPlayer();
  }

  Future togglePlaying({required VoidCallback whenFinished}) async {
    if (_audioPlayer!.isStopped) {
      await _play(whenFinished);
    } else {
      await _stop();
    }
  }
}
